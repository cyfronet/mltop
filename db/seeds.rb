def data_yaml(name)
  YAML.load_file File.join(Rails.root, "db", "data", "#{name}.yml")
end

tasks =
  data_yaml("tasks").map do |slug, data|
    Task.find_or_initialize_by(slug:) do |task|
      task.update!(
        name:        data["name"],
        info:        data["info"],
        description: data["description"],
        from:        data["from"],
        to:          data["to"]
      )
    end
  end.to_h { |t| [ t.slug, t ] }

data_yaml("evaluators").each do |_, data|
  evaluator = Evaluator.find_or_initialize_by(name: data["name"])
  evaluator.update!(script: data["script"], host: data["host"])

  data["tasks"].each { |slug| evaluator.task_evaluators.find_or_create_by(task: tasks[slug]) }
  data["metrics"].each do |hsh|
    metric = evaluator.metrics.find_or_initialize_by(name: hsh["name"])
    metric.update!(order: hsh["order"])
  end
end
