class TestSetFaker::SsumFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    icsi_path = File.join(@task_dir, "ICSI")
    FileUtils.mkdir_p(icsi_path)

    icsi_lang_path = File.join(icsi_path, "en")
    FileUtils.mkdir_p(icsi_lang_path)

    create_placeholder_file(icsi_lang_path, "audios.tar.gz")
    create_placeholder_file(icsi_lang_path, "ref.jsonl")
  end
end
