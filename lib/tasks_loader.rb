class TasksLoader
  def initialize(tasks_yaml_path, evaluators_yaml_path, challenge_id)
    @tasks_yaml_path = tasks_yaml_path
    @evaluators_yaml_path = evaluators_yaml_path
    @challenge_id = challenge_id
  end

  def import!
    tasks =
      data_yaml(@tasks_yaml_path).map do |slug, data|
        Task.find_or_initialize_by(slug:, challenge_id: @challenge_id) do |task|
          task.update!(
            name:        data["name"],
            info:        data["info"],
            description: data["description"],
            from:        data["from"],
            to:          data["to"]
          )
        end
      end.to_h { |t| [ t.slug, t ] }

    data_yaml(@evaluators_yaml_path).each do |_, data|
      evaluator = Evaluator.find_or_initialize_by(name: data["name"], challenge_id: @challenge_id)
      evaluator.update!(script: data["script"], host: data["host"])

      data["tasks"].each { |slug| evaluator.task_evaluators.find_or_create_by(task: tasks[slug]) }
      data["metrics"].each do |hsh|
        metric = evaluator.metrics.find_or_initialize_by(name: hsh["name"])
        metric.update!(order: hsh["order"])
      end
    end
  end

  private
    def data_yaml(path)
      YAML.load_file path
    end
end
