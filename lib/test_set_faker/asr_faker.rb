class TestSetFaker::AsrFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    covost_path = File.join(@task_dir, "COVOST")
    FileUtils.mkdir_p(covost_path)
    [ "de", "es", "fr", "it" ].each do |lang|
      lang_path = File.join(covost_path, lang)
      FileUtils.mkdir_p(lang_path)
      create_placeholder_file(lang_path, "audios.tar.gz")
      create_placeholder_file(lang_path, "test.#{lang}")
    end

    mustc_path = File.join(@task_dir, "MUSTC")
    FileUtils.mkdir_p(mustc_path)
    mustc_lang_path = File.join(mustc_path, "en")
    FileUtils.mkdir_p(mustc_lang_path)
    create_placeholder_file(mustc_lang_path, "_audios.tar.gz")
    create_placeholder_file(mustc_lang_path, "tst-COMMON.yaml")
    create_placeholder_file(mustc_lang_path, "tst-COMMON.en")

    acl6060_path = File.join(@task_dir, "ACL6060")
    FileUtils.mkdir_p(acl6060_path)
    create_placeholder_file(acl6060_path, "audios.tar.gz")

    acl6060_lang_path = File.join(acl6060_path, "en")
    FileUtils.mkdir_p(acl6060_lang_path)
    create_placeholder_file(acl6060_lang_path, "eval.en")

    dipco_path = File.join(@task_dir, "DIPCO")
    FileUtils.mkdir_p(dipco_path)
    dipco_lang_path = File.join(dipco_path, "en")
    FileUtils.mkdir_p(dipco_lang_path)
    create_placeholder_file(dipco_lang_path, "close-talk.audios.tar.gz")
    create_placeholder_file(dipco_lang_path, "close-talk.en")
  end
end
