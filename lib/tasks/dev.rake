if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task recreate: %w[ db:reset ] do
      include ActionView::Helpers::TextHelper

      uid = ENV["UID"] || raise("Please put your keycloak UID to .env file (echo \"UID=my-uid\" >> .env)")
      me = User.create!(uid:, plgrid_login: "will-be-updated",
                        email: "will@be.updated",
                        roles_mask: 1)

      Task.where(slug: [ "ST" ]).each do |task|
        hypotheses_ids =
          (1..(ENV["MODELS_COUNT"]&.to_i || 10)).map do |i|
            model = Model.create!(
              owner: me,
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
  end
end
