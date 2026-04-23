namespace :tasks do
  desc "Summarizes score for a task in a JSON format."
  task :print_scores, [ :task_id ] => [ :environment ] do |t, args|
    task = Task.find(args.fetch(:task_id))

    result = { task.name => {} }

    # Eager load everything we need
    task_models = task.task_models
      .includes(model: { hypotheses: { test_set_entry: { task_test_set: :test_set }, evaluations: { scores: :metric, evaluator: {} } } })

    task_models.each do |task_model|
      model = task_model.model
      result[task.name][model.name] ||= {}

      model.hypotheses.each do |hypothesis|
        test_set_entry = hypothesis.test_set_entry
        next unless test_set_entry.task_test_set.task_id == task.id

        test_set = test_set_entry.task_test_set.test_set
        entry_key = test_set_entry.to_s

        result[task.name][model.name][test_set.name] ||= {}
        result[task.name][model.name][test_set.name][entry_key] ||= {}

        hypothesis.evaluations.each do |evaluation|
          evaluation.scores.each do |score|
            metric_name = score.metric.name
            result[task.name][model.name][test_set.name][entry_key][metric_name] = score.value
          end
        end
      end
    end

    puts JSON.pretty_generate(result)
  end
end
