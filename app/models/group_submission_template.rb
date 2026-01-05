require "zip"

class GroupSubmissionTemplate
  def initialize(model)
    @model = model
  end

  def create
    temp_file = Tempfile.new([ "submission_template", ".zip" ])

    Zip::File.open(temp_file.path, create: true) do |zip_file|
      test_set_entries.each do |tse|
        folder_path = File.join(tse.task.name, tse.test_set.name)
        file_name = "#{tse.source_language}_#{tse.target_language}.txt"
        full_path = File.join(folder_path, file_name)

        zip_file.get_output_stream(full_path) do |f|
          f.puts "# Replace this line with your hypothesis for #{tse.source_language}-#{tse.target_language}"
        end
      end
    end

    temp_file
  end

  private

    def test_set_entries
      TestSetEntry.joins(:task)
                  .where(tasks: { id: @model.tasks.select(:id) })
                  .includes(:task, :test_set)
    end
end
