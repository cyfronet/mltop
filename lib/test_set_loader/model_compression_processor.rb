class TestSetLoader::ModelCompressionProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "ACL6060"   then process_shared_video(entry)
      when "BUSINESSNEWS"   then process_shared_video(entry)
      when "CALLCENTER"   then process_shared_audio(entry)
      when "CHALLENGEACCENT"   then process_shared_audio(entry)
      when "TVSERIES"   then process_shared_video(entry)
      when "YOUTUBE"   then process_shared_audio(entry)
      else                          not_supported(entry)
      end
    end
  end

  private
    def process_shared_audio(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(dir, "_audios.tar.gz"),
          child_with_extension(entry, ".#{target}")
        ]
      end
    end

    def process_shared_video(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(dir, "_videos.tar.gz"),
          child_with_extension(entry, ".#{target}")
        ]
      end
    end
end
