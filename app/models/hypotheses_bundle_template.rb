require "zip"

class HypothesesBundleTemplate
  def initialize(model)
    @model = model
  end

  def generate
    Zip::OutputStream.write_buffer do |zos|
      test_set_entries.each do |tse|
        path = File.join(tse.task.slug, tse.test_set.name, "#{tse.source_language}_#{tse.target_language}.txt")
        zos.put_next_entry(path)
        zos.puts "# Replace this line with your hypothesis for #{tse.source_language}-#{tse.target_language}"
      end
    end.string
  end

  private

    def test_set_entries
      TestSetEntry.joins(:task)
                  .where(tasks: { id: @model.tasks.select(:id) })
                  .includes(:task, :test_set)
    end
end
