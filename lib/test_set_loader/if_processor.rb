class TestSetLoader::IfProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "IFSHORT26"   then process_shared_audio(entry)
      when "IFLONG26"   then process_shared_audio(entry)
      else                          not_supported(entry)
      end
    end
  end

  private
    def process_shared_audio(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(dir, "_audios.tar.gz"),
          child_with_extension(entry, ".#{target}.xml")
        ]
      end
    end

    def process_shared_video(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(dir, "_videos.tar.gz"),
          child_with_extension(entry, ".#{target}.xml")
        ]
      end
    end
end
