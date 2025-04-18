class TestSetLoader::ModelCompressionProcessor < TestSetLoader::Processor
  def import!
    dir.each_child do |entry|
      next if entry.file?

      case entry.basename.to_s
      when "IWSLT25INSTRUCT"   then process_shared_audio(entry)
      else                          not_supported(entry)
      end
    end
  end

  private
    def process_shared_audio(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(dir, "_audios.tar.gz"),
          child_with_extension(entry, ".#{target}"),
          child_with_extension(entry, ".#{source}")
        ]
      end
    end
end
