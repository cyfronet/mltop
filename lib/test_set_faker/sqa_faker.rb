class TestSetFaker::SqaFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    spokensquad_path = File.join(@task_dir, "SPOKENSQUAD")
    FileUtils.mkdir_p(spokensquad_path)

    spokensquad_lang_path = File.join(spokensquad_path, "en")
    FileUtils.mkdir_p(spokensquad_lang_path)

    create_placeholder_file(spokensquad_lang_path, "SPOKENSQUAD_audios.tar.gz")
    create_placeholder_file(spokensquad_lang_path, "SPOKENSQUAD.json")
  end
end
