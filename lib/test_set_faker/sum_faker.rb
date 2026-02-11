class TestSetFaker::SumFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    [ "ICSI", "AUTOMIN" ].each do |test_set|
      test_set_path = File.join(@task_dir, test_set)
      FileUtils.mkdir_p(test_set_path)

      lang_path = File.join(test_set_path, "en")
      FileUtils.mkdir_p(lang_path)

      create_placeholder_file(lang_path, "src.jsonl")
      create_placeholder_file(lang_path, "ref.jsonl")
    end
  end
end
