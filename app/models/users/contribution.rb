require "zip"

module Users::Contribution
  extend ActiveSupport::Concern

  def all_hypothesis
    tmp_dir = Dir.mktmpdir
    ::Zip::OutputStream.open("#{tmp_dir}.zip") do |zip_stream|
      models.preload(tasks: :test_set_entries).each do |model|
        model.tasks.each do |task|
          model.hypothesis.preload(:input_blob, test_set_entry: :test_set).where(test_set_entry: task.test_set_entries).with_attached_input.each do |hypothesis|
            if filename = [ "user-#{id}", task.name, hypothesis.model.name, hypothesis.test_set_entry.test_set.name, hypothesis.test_set_entry.to_s ].join("/")
              zip_stream.put_next_entry(filename)
              hypothesis.input.download do |chunk|
                zip_stream.write(chunk)
              end
            end
          end
        end
      end
    end
    "#{tmp_dir}.zip"
  ensure
    FileUtils.rm_rf(tmp_dir)
  end
end
