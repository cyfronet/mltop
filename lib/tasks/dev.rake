if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task :recreate, [ "user_login" ] => [ :environment ] do |t, args|
      task("db:drop").invoke
      system "rm -rf #{File.join(Rails.root, "storage", "*/")}"

      task("db:create").invoke
      task("db:schema:load").invoke
      task("db:migrate").invoke
      task("db:seed").invoke

      uid = ENV["UID"] || raise("Please put your keycloak UID to .env file (echo \"UID=my-uid\" >> .env)")
      User.create!(uid:, plgrid_login: "will-be-updated",
                        email: "will@be.updated",
                        roles: [ :admin ])


      puts "DB set up complete, initializing test sets.."
      Rake::Task["test_sets:synchronize"].invoke(args.fetch(:user_login))

      puts "Test sets created, mocking data for ST"
      Rake::Task["dev:faked_st_models"].invoke
    end

    task faked_st_models: :environment do
      owner = User.first

      task = Task.find_by(slug: "ST")
      hypotheses_ids =
        (1..(ENV["MODELS_COUNT"]&.to_i || 10)).map do |i|
          model = Model.create!(
            owner:,
            name: "#{task.name} - Model #{i + 1}",
            description: Faker::Lorem.paragraphs(number: 25).join(" "),
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
end
