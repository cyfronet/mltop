module User::Contribution
  extend ActiveSupport::Concern

  def all_hypothesis
    tmp_dir = Dir.mktmpdir
    Zip::File.open("#{tmp_dir}.zip", Zip::File::CREATE) do |zf|
      # entries.where(task:).preload(:input_blob).with_attached_input.each do |entry|
      #   if filename = entry.input_file_name
      #     File.open(File.join(tmp_dir, filename), "wb") do |file|
      #       entry.input.download { |chunk| file.write(chunk) }
      #     end
      #     zf.add(filename, File.join(tmp_dir, filename))
      #   end
      # end
    end

    "#{tmp_dir}.zip"
  ensure
    FileUtils.rm_rf(tmp_dir)
  end
end
