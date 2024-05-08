if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task seed: "db:setup" do
      Task.find_or_create_by!(name: "Automatic Speech Recognition (ASR)", from: :audio, to: :text)
      st = Task.find_or_create_by!(name: "Speech-to-text Translation (ST)", from: :audio, to: :text)
      Task.find_or_create_by!(name: "Machine (text-to-text) Translation (MT)", from: :text, to: :text)
      Task.find_or_create_by!(name: "Lips Reading (LR)", from: :movie, to: :text)

      en_pl = st.subtasks.find_or_create_by!(name: "en->pl", source_language: "en", target_language: "pl")
      en_it = st.subtasks.find_or_create_by!(name: "en->it", source_language: "en", target_language: "it")

      mustc = st.test_sets.find_or_create_by!(name: "MUSTC")
      mustc.subtask_test_sets.find_or_create_by!(subtask: en_pl)
      mustc.subtask_test_sets.find_or_create_by!(subtask: en_it)

      flores = st.test_sets.find_or_create_by!(name: "FLORES")
      flores.subtask_test_sets.find_or_create_by!(subtask: en_pl)
      flores.subtask_test_sets.find_or_create_by!(subtask: en_it)

      sacrebleu = Evaluator.find_or_create_by!(name: "Sacrebleu")
      sacrebleu.metrics.find_or_create_by!(name: "blue")
      sacrebleu.metrics.find_or_create_by!(name: "chrf")
      sacrebleu.metrics.find_or_create_by!(name: "ter")
      bleurt = Evaluator.find_or_create_by!(name: "bleurt")
      bleurt.metrics.find_or_create_by!(name: "bleurt")

      st.task_evaluators.find_or_create_by!(evaluator: sacrebleu)
      st.task_evaluators.find_or_create_by!(evaluator: bleurt)

      [ st ].each do |task|
        evaluators = task.evaluators
        subtasks_test_sets = SubtaskTestSet.joins(:subtask).where(subtask: { task: })

        (ENV["MODELS_COUNT"]&.to_i || 10).times do |i|
          model = task.models.find_or_create_by!(name: "#{task.name} - Model #{i + 1}")

          evaluators.each do |evaluator|
            subtasks_test_sets.each do |subtask_test_set|
              evaluation = model.evaluations.find_or_create_by!(evaluator:, subtask_test_set:)
              evaluation.scores.destroy_all

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
