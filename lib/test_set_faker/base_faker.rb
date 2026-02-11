class TestSetFaker::BaseFaker
  def initialize(tasks_path, task_name)
    @task_dir = File.join(tasks_path, task_name)
  end

  private

    def create_placeholder_file(dir, filename)
      filepath = File.join(dir, filename)

      File.write(filepath, "# Placeholder file")
    end
end
