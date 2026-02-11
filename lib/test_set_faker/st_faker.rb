class TestSetFaker::StFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    test_sets = {
      "COVOST" => [ "en-de", "es-en", "fr-en", "it-en" ],
      "MUSTC" => [ "en-de" ],
      "MTEDX" => [ "en-es" ],
      "ACL6060" => [ "en-de", "en-fr" ]
    }

    test_sets.each do |test_set, lang_pairs|
      test_set_path = File.join(@task_dir, test_set)
      FileUtils.mkdir_p(test_set_path)

      if test_set == "ACL6060"
        create_placeholder_file(test_set_path, "_audios.tar.gz")
      end

      lang_pairs.each do |lang_pair|
        source, target = lang_pair.split("-")
        lang_path = File.join(test_set_path, lang_pair)
        FileUtils.mkdir_p(lang_path)

        if test_set == "COVOST"
          create_placeholder_file(lang_path, "test.#{lang_pair}.#{source}")
          create_placeholder_file(lang_path, "test.#{lang_pair}.#{target}")
          create_placeholder_file(lang_path, "#{test_set}.#{source}")
          create_placeholder_file(lang_path, "#{test_set}.#{target}")
          create_placeholder_file(lang_path, "#{test_set}_audios.tar.gz")
          create_placeholder_file(lang_path, "#{test_set}tst-COMMON.yaml")
          create_placeholder_file(lang_path, "#{test_set}test.yaml")
          create_placeholder_file(lang_path, "ST_#{test_set}_#{source}.tgz")
        elsif test_set == "MUSTC"
          create_placeholder_file(lang_path, "test.#{lang_pair}.#{source}")
          create_placeholder_file(lang_path, "test.#{lang_pair}.#{target}")
          create_placeholder_file(lang_path, "#{test_set}.#{source}")
          create_placeholder_file(lang_path, "#{test_set}.#{target}")
          create_placeholder_file(lang_path, "#{test_set}_audios.tar.gz")
          create_placeholder_file(lang_path, "#{test_set}tst-COMMON.yaml")
          create_placeholder_file(lang_path, "#{test_set}test.yaml")
          create_placeholder_file(lang_path, "ST_#{test_set}_#{source}.tgz")
        elsif test_set == "MTEDX"
          create_placeholder_file(lang_path, "test.#{lang_pair}.#{source}")
          create_placeholder_file(lang_path, "test.#{lang_pair}.#{target}")
          create_placeholder_file(lang_path, "#{test_set}.#{source}")
          create_placeholder_file(lang_path, "#{test_set}.#{target}")
          create_placeholder_file(lang_path, "#{test_set}_audios.tar.gz")
          create_placeholder_file(lang_path, "#{test_set}tst-COMMON.yaml")
          create_placeholder_file(lang_path, "#{test_set}test.yaml")
          create_placeholder_file(lang_path, "ST_#{test_set}_#{source}.tgz")
        elsif test_set == "ACL6060"
          create_placeholder_file(lang_path, ".#{target}")
          create_placeholder_file(lang_path, ".#{source}")
        end
      end
    end
  end
end
