class TestSetFaker::LipreadFaker < TestSetFaker::BaseFaker
  def generate
    FileUtils.mkdir_p(@task_dir)

    lrs2_path = File.join(@task_dir, "LRS2")
    FileUtils.mkdir_p(lrs2_path)

    lrs2_lang_path = File.join(lrs2_path, "en")
    FileUtils.mkdir_p(lrs2_lang_path)

    create_placeholder_file(lrs2_lang_path, "en_videos.tar.gz")
    create_placeholder_file(lrs2_lang_path, "ref.en.tsv.sorted")
  end
end
