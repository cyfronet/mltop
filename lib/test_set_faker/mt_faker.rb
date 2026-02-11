class TestSetFaker::MtFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    test_sets = {
      "FLORES" => [ "en-de", "en-cs", "en-es", "en-fr", "en-it", "en-nl", "en-pt", "en-ro" ],
      "ACL6060" => [ "en-de", "en-fr" ]
    }

    test_sets.each do |test_set, lang_pairs|
      test_set_path = File.join(@task_dir, test_set)
      FileUtils.mkdir_p(test_set_path)

      lang_pairs.each do |lang_pair|
        source, target = lang_pair.split("-")
        lang_path = File.join(test_set_path, lang_pair)
        FileUtils.mkdir_p(lang_path)

        create_placeholder_file(lang_path, "devtest.#{lang_pair}.#{source}")
        create_placeholder_file(lang_path, "devtest.#{lang_pair}.#{target}")
        create_placeholder_file(lang_path, "#{test_set}.#{source}")
        create_placeholder_file(lang_path, "#{test_set}.#{target}")
      end
    end
  end
end
