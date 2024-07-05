if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task recreate: %w[ db:drop db:create db:migrate db:seed ] do
      include ActionView::Helpers::TextHelper
      # text to text
      Task.create!(name: "Machine translation", slug: "MT", from: :text, to: :text)
      Task.create!(name: "Sumarization", slug: "SUM", from: :text, to: :text)

      # audio to text
      Task.create!(name: "Automatic Speech Recognition", slug: "ASR", from: :audio, to: :text)
      st = Task.create!(name: "Speech Translation", slug: "ST", from: :audio, to: :text)
      Task.create!(name: "Speech Sumarization", slug: "SSUM", from: :audio, to: :text)
      Task.create!(name: "Speech Question-Anwering", slug: "SQA", from: :audio, to: :text)
      Task.create!(name: "Spoken Language Understanding", slug: "SLU", from: :audio, to: :text)

      # video to text
      Task.create!(name: "Lip Reading", slug: "LIPREAD", from: :video, to: :text)

      # text to audio
      Task.create!(name: "Text-to-Speech", slug: "TTS", from: :text, to: :audio)

      # text to video
      Task.create!(name: "Lep Generation", slug: "LIPGEN", from: :text, to: :audio)

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
            st.subtasks.create!(
              name: "#{source}->#{target}",
              source_language: source, target_language: target
            )
          end

      mustc = TestSet.create!(name: "MUSTC", description: simple_format(Faker::Lorem.paragraphs(number: 10).join(" ")))
      flores = TestSet.create!(name: "FLORES", description: simple_format(Faker::Lorem.paragraphs(number: 10).join(" ")))

      TaskTestSet.create!(task: st, test_set: mustc)
      TaskTestSet.create!(task: st, test_set: flores)

      [ mustc, flores ].each do |test_set|
        entries_map =
          languages
            .map do |language|
              test_set.entries.create!(
                language:,
                input: { io: StringIO.new(Faker::Lorem.sentences(number: 100).join("\n")), filename: "#{language}.txt" }
              )
            end
            .index_by(&:language)

        subtasks.each do |subtask|
          subtask.groundtruths.create!(
            test_set_entry: entries_map[subtask.source_language],
            input: { io: StringIO.new(Faker::Lorem.sentences(number: 100).join("\n")), filename: "#{subtask.target_language}.txt" }
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

      uid = ENV["UID"] || raise("Please put your keycloak UID to .env file (echo \"UID=my-uid\" >> .env)")
      me = User.create!(uid:, plgrid_login: "will-be-updated",
                        email: "will@be.updated",
                        roles_mask: 1)

      [ st ].each do |task|
        hypotheses_ids =
          (1..(ENV["MODELS_COUNT"]&.to_i || 10)).map do |i|
            model = Model.create!(
              owner: me,
              name: "#{task.name} - Model #{i + 1}",
              description: simple_format(Faker::Lorem.paragraphs(number: 25).join(" ")),
              task_ids: [ task.id ]
            )

            Groundtruth.joins(:subtask).where(subtask: { task_id: task }).map do |gt|
              gt.hypotheses.create!(
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
