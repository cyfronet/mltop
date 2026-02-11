class TestSetFaker::TtsFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    ljspeech_path = File.join(@task_dir, "LJSPEECH")
    FileUtils.mkdir_p(ljspeech_path)

    ljspeech_lang_path = File.join(ljspeech_path, "en")
    FileUtils.mkdir_p(ljspeech_lang_path)

    create_placeholder_file(ljspeech_lang_path, ".src.en.tsv")
    create_placeholder_file(ljspeech_lang_path, ".ref.en.tsv")
  end
end
