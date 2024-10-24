def data_yaml(name)
  YAML.load_file File.join(Rails.root, "db", "data", "#{name}.yml")
end

tasks =
  data_yaml("tasks").map do |slug, data|
    Task.find_or_initialize_by(slug:) do |task|
      if task.new_record?
        task.update!(
          name:        data["name"],
          info:        data["info"],
          description: data["description"],
          from:        data["from"],
          to:          data["to"]
        )
      end
    end
  end.to_h { |t| [ t.slug, t ] }

data_yaml("evaluators").each do |_, data|
  Evaluator.find_or_initialize_by(name: data["name"]) do |evaluator|
    evaluator.update!(
      script:          data["script"],
      host:            data["host"],
      metrics:         data["metrics"].map { |name| Metric.build(name:) },
      task_evaluators: data["tasks"].map { |slug| TaskEvaluator.new(task: tasks[slug]) }
    )
  end
end
