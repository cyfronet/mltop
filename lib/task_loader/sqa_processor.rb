class TaskLoader::SqaProcessor < TaskLoader::Processor
  def import!
    dir.each_child do |entry|
      entry.basename.to_s == "SPOKENSQUAD" ? process_spokensquad(entry) : not_supported(entry)
    end
  end

  private
    def process_spokensquad(dir)
      single_language_process(dir) do |entry, _name, _lang|
        [
          child_with_extension(entry, "tar.gz"),
          child_with_extension(entry, "json")
        ]
      end
    end
end
