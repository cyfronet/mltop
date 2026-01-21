require "test_helper"
require "zip"

class HypothesesBundleTemplateTest < ActiveSupport::TestCase
  test "creates zip entry with task/test_set folder and language file name" do
    task = tasks(:st)
    model = create(:model, tasks: [ task ])
    template = HypothesesBundleTemplate.new(model)
    test_set_entries = TestSetEntry.joins(:task)
                  .where(tasks: { id: model.tasks.select(:id) })
                  .includes(:task, :test_set)
    expected_names = test_set_entries.map do |tse|
      [ tse.task.slug, tse.test_set.name, "#{tse.source_language}_#{tse.target_language}.txt" ].join("/")
    end

    zip_file = template.generate
    Zip::File.open_buffer(zip_file) do |zip|
      zip.entries.each do |entry|
        assert_includes expected_names, entry.name
      end
    end
  end
end
