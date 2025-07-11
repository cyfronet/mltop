class TestSetLoader::SluProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "SPEECHMASSIVE" then process_speech_massive(entry)
      when "SLURP"         then process_slurp(entry)
      else                       not_supported(entry)
      end
    end
  end

  private

  def process_speech_massive(dir)
    single_language_process(dir) do |entry, _name, lang|
      [
        child_with_extension(entry, "#{lang}_audios.tar.gz"),
        child_with_extension(entry, ".#{lang}")
      ]
    end
  end

  def process_slurp(dir)
    single_language_process(dir) do |entry, _name, lang|
      [
        child_with_extension(entry, "en_audios.tar.gz"),
        child_with_extension(entry, ".en")
      ]
    end
  end
end
