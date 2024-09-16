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
      Task.create!(name: "Lip Generation", slug: "LIPGEN", from: :text, to: :audio)

      Task.all.each do |task|
        task.update(
          info: Faker::Lorem.paragraphs(number: 3).join(" "),
          description: simple_format(Faker::Lorem.paragraphs(number: 25).join(" "))
        )
      end


      sacrebleu = Evaluator.create!(name: "Sacrebleu", script: dummy_script([ "blue", "chrf", "ter" ]), host: "ares.cyfronet.pl")
      sacrebleu.metrics.create!(name: "blue")
      sacrebleu.metrics.create!(name: "chrf")
      sacrebleu.metrics.create!(name: "ter")

      bleurt = Evaluator.create!(name: "bleurt", script: dummy_script([ "bleurt" ]), host: "ares.cyfronet.pl")
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

  def dummy_script(metric_names)
    scores = { scores: metric_names.map do |metric|
        [ metric, rand(100.0) ]
      end.to_h
    }
    <<~SCR
      #SBATCH -A plgmeetween2004-cpu
      #SBATCH -p plgrid
      #SBATCH --ntasks-per-node=1
      #SBATCH --time=00:01:00
      #!/bin/bash -l

      echo $GROUNDTRUTH_URL

      curl -X POST $RESULTS_URL \\
      -L --location-trusted \\
      -H "Content-Type:application/json" \\
      -H "Authorization:Token $TOKEN" \\
      -d '#{scores.to_json}'
    SCR
  end
end
