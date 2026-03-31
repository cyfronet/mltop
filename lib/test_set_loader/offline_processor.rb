class TestSetLoader::OfflineProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "TRACK1_ACL6060"   then process_shared_video(entry)
      when "TRACK1_BUSINESSNEWS"   then process_shared_video(entry)
      when "TRACK1_CALLCENTER"   then process_shared_audio(entry)
      when "TRACK1_CHALLENGEACCENT"   then process_shared_audio(entry)
      when "TRACK1_TVSERIES"   then process_shared_video(entry)
      when "TRACK1_YOUTUBE"   then process_shared_audio(entry)
      when "TRACK1_TTS1"   then process_shared_audio(entry)
      when "TRACK1_TTS2"   then process_shared_audio(entry)
      when "TRACK1_TTS3"   then process_shared_audio(entry)
      when "TRACK2_MULTILINGUAL"   then process_shared_audio(entry)
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
