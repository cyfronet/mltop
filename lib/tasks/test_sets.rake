namespace :test_sets do
  task :synchronize, [ :user_login ] => [ :environment ] do |t, args|
    require "task_loader"

    loader = TaskLoader.new(username: args.fetch(:user_login))

    loader.synchronize_with_remote!

    if TestSet.count.positive?
      puts "Test sets already in the DB, do you want to remove them and import a new one from Ares [y/n]?"
      if gets.chomp == "y"
        TestSet.destroy_all
      end
    end
    loader.import!
  end

  task mock_st: :environment do
    include ActionView::Helpers::TextHelper

    owner = User.first

    task = Task.find_by(slug: "ST")
    hypotheses_ids =
      (1..(ENV["MODELS_COUNT"]&.to_i || 10)).map do |i|
        model = Model.create!(
          owner:,
          name: "#{task.name} - Model #{i + 1}",
          description: simple_format(Faker::Lorem.paragraphs(number: 25).join(" ")),
          task_ids: [ task.id ]
        )

        TestSetEntry.where(task:).map do |entry|
          entry.hypotheses.create!(
            model:,
            input: { io: StringIO.new(Faker::Lorem.sentences(number: 100).join("\n")), filename: "hypothesis.txt" }
          )
        end
      end
        .flatten.map(&:id)

    evaluations_attrs =
      task.evaluators.pluck(:id).product(hypotheses_ids).map do |evaluator_id, hypothesis_id|
        { evaluator_id:, hypothesis_id: }
      end
    evaluations = Evaluation.insert_all!(evaluations_attrs, returning: %w[ id evaluator_id ]).rows
    metrics = Metric
      .joins(evaluator: :tasks)
      .where(evaluator: { tasks: task })
      .pluck(:id, :evaluator_id)
      .group_by(&:second)
      .transform_values { |v| v.map(&:first) }

    scores_attrs =
      evaluations.map do |evaluation_id, evaluator_id|
        metrics[evaluator_id].map do |metric_id|
          { evaluation_id:, metric_id:, value: Random.rand(100) }
        end
      end.flatten
    Score.insert_all!(scores_attrs)
  end
end
