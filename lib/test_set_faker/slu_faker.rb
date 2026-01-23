class TestSetFaker::SluFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    slurp_path = File.join(@task_dir, "SLURP")
    FileUtils.mkdir_p(slurp_path)

    en_path = File.join(slurp_path, "en")
    FileUtils.mkdir_p(en_path)
    create_placeholder_file(en_path, "en_audios.tar.gz")
    create_placeholder_file(en_path, ".en")

    speechmassive_path = File.join(@task_dir, "SPEECHMASSIVE")
    FileUtils.mkdir_p(speechmassive_path)

    [ "de", "fr" ].each do |lang|
      lang_path = File.join(speechmassive_path, lang)
      FileUtils.mkdir_p(lang_path)

      create_placeholder_file(lang_path, "#{lang}_audios.tar.gz")
      create_placeholder_file(lang_path, ".#{lang}")
    end
  end
end
