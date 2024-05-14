if Rails.env.local?

  namespace :dev do
    desc "Sample data for local development environment"
    task recreate: %w[ db:drop db:create db:migrate db:seed db:setup ] do
      include ActionView::Helpers::TextHelper
      Task.create!(name: "Automatic Speech Recognition", slug: "ASR", from: :audio, to: :text)
      st = Task.create!(name: "Speech-to-text Translation", slug: "ST", from: :audio, to: :text)
      Task.create!(name: "Machine (text-to-text) TRanslation", slug: "MT", from: :text, to: :text)
      Task.create!(name: "Lips Reading", slug: "LR", from: :movie, to: :text)

      Task.all.each do |task|
        task.update(
          info: Faker::Lorem.paragraphs(number: 3).join(" "),
          description: simple_format(Faker::Lorem.paragraphs(number: 25).join(" "))
        )
      end

      languages = %w[ pl it de fr es pr th ]

      subtasks =
        languages
          .product(languages)
          .reject { |tuple| tuple.first == tuple.last }
          .map do |source, target|
            st.subtasks.create!(name: "#{source}->#{target}",
                                source_language: source, target_language: target)
          end

      mustc = st.test_sets.create!(name: "MUSTC", description: simple_format(Faker::Lorem.paragraphs(number: 10).join(" ")))
      flores = st.test_sets.create!(name: "FLORES", description: simple_format(Faker::Lorem.paragraphs(number: 10).join(" ")))
      [ mustc, flores ].each do |test_set|
        subtasks.each do |subtask|
          test_set.subtask_test_sets.create!(
            subtask: subtask,
            input: { io: StringIO.new(Faker::Lorem.sentences(number: 100).join("\n")), filename: "input.txt" },
            reference: { io: StringIO.new(Faker::Lorem.sentences(number: 100).join("\n")), filename: "input.txt" }
          )
        end
      end

      sacrebleu = Evaluator.create!(name: "Sacrebleu")
      sacrebleu.metrics.create!(name: "blue")
      sacrebleu.metrics.create!(name: "chrf")
      sacrebleu.metrics.create!(name: "ter")

      bleurt = Evaluator.create!(name: "bleurt")
      bleurt.metrics.create!(name: "bleurt")

      st.task_evaluators.create!(evaluator: sacrebleu)
      st.task_evaluators.create!(evaluator: bleurt)

      [ st ].each do |task|
        evaluators = task.evaluators
        subtasks_test_sets = SubtaskTestSet.joins(:subtask).where(subtask: { task: })

        (ENV["MODELS_COUNT"]&.to_i || 10).times do |i|
          model = task.models.create!(
            name: "#{task.name} - Model #{i + 1}",
            description: simple_format(Faker::Lorem.paragraphs(number: 25).join(" "))
          )

          evaluators.each do |evaluator|
            subtasks_test_sets.each do |subtask_test_set|
              evaluation = model.evaluations.create!(evaluator:, subtask_test_set:)

              evaluator.metrics.each do |metric|
                evaluation.scores.create!(metric:, value: Random.rand(100))
              end
            end
          end
        end
      end
    end
  end
end
