include ActionView::Helpers::TextHelper

def create_or_find_test_set(test_set_name)
  test_set = TestSet.find_or_create_by!(name: test_set_name) do |ts|
    ts.description = simple_format(Faker::Lorem.paragraphs(number: 10).join(" "))
  end
  test_set
end

def download_and_create_tar(ssh_connection, source_file_tgz_path, source_speaker_segmentation_path, test_set_name, task_slug, source_lang)
  main_source_file = Tempfile.new([ "#{test_set_name}_#{task_slug}_#{source_lang}.tar.gz" ])
  temp_tgz_file = Tempfile.new([ "recordings.tar.gz" ])
  temp_yaml_file = Tempfile.new([ "speaker_segmentation.yaml" ])

  begin
    # Download the source file and segmentation file
    ssh_connection.scp.download!(source_file_tgz_path, temp_tgz_file.path)
    ssh_connection.scp.download!(source_speaker_segmentation_path, temp_yaml_file.path)

    # Create a tar.gz file with the source file and segmentation file
    # Command for tar perhaps can be better, this one is GPT-3 generated
    system("tar -czf #{main_source_file.path} -C #{File.dirname(temp_tgz_file.path)} --transform 's/\.yaml.*/.yaml/' #{File.basename(temp_tgz_file.path)} -C #{File.dirname(temp_yaml_file.path)} --transform 's/\.tar\.gz.*/.tar.gz/' #{File.basename(temp_yaml_file.path)}")

    main_source_file
  ensure
    temp_tgz_file.close
    temp_tgz_file.unlink
    temp_yaml_file.close
    temp_yaml_file.unlink
  end
end



class SSHTaskProcessor
  def initialize(root_path)
    @root_path = root_path
    @task_slug = File.basename(root_path)
  end


  def process(ssh_connection)
    raise NotImplementedError
  end

  def define_mime_type(extension)
    if extension == "txt"
      content_type = "text/plain"
    elsif extension == "tar.gz" || extension == "tar"
      content_type = "application/gzip"
    elsif extension == "json"
      content_type = "application/json"
    end
    content_type
  end

  def save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_file_content_io, groundtruth_file_content_io, source_extension = "txt", groundtruth_extension = "txt")
    source_content_type = define_mime_type(source_extension)
    groundtruth_content_type = define_mime_type(groundtruth_extension)

    task = Task.find_by(slug: @task_slug)
    test_set_entry = TestSetEntry.new(
        test_set: test_set,
        task: task,
        source_language: source_lang,
        target_language: target_lang
      )
      test_set_entry.input.attach(
        io: source_file_content_io,
        filename: "entry_#{@task_slug}_#{test_set.name}_#{source_lang}.#{source_extension}",
        content_type: source_content_type
      )

      test_set_entry.groundtruth.attach(
        io: groundtruth_file_content_io,
        filename: "entry_#{@task_slug}_#{test_set.name}_#{target_lang}.#{groundtruth_extension}",
        content_type: groundtruth_content_type
      )
      test_set_entry.save!
  end
end


class SQAProcessor < SSHTaskProcessor
  def process(ssh_connection)
    task_test_set_list = ssh_connection.exec!("ls #{@root_path}").split("\n")
    task_test_set_list.each do |test_set_name|
      if test_set_name == "SPOKENSQUAD"
        process_sqa_task_spokensquad(File.join(@root_path, test_set_name), ssh_connection)
      else
        puts "Test set #{test_set_name} not supported yet for #{@task_slug}"
      end
    end
  end


  def process_sqa_task_spokensquad(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set = create_or_find_test_set(test_set_name)
    source_lang = "en"
    target_lang = source_lang
    if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
      puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
      return
    end

    puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
    source_file_tgz_path = "#{root_path}/en/Spoken-SQUAD.dev.en_audios.tar.gz"
    source_temp_file = Tempfile.new([ "#{test_set_name}_#{@task_slug}_#{source_lang}.tar.gz" ])
    begin
      ssh_connection.scp.download!(source_file_tgz_path, source_temp_file.path)
      groundtruth_file_content = ssh_connection.exec!("ls #{root_path}/en/Spoken-SQUAD.dev.en.json| xargs cat").to_s

      groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
      source_temp_file_io = File.open(source_temp_file.path)
      save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "json")
    ensure
        source_temp_file.close
        source_temp_file.unlink
    end
  end
end


class MTProcessor < SSHTaskProcessor
  def process(ssh_connection)
    task_test_set_list = ssh_connection.exec!("ls #{@root_path}").split("\n")
    task_test_set_list.each do |test_set_name|
      process_mt_task(File.join(@root_path, test_set_name), ssh_connection)
    end
  end

  def process_mt_task(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set_entries_dir_list =  ssh_connection.exec!("ls #{root_path}").split("\n")
    test_set = create_or_find_test_set(test_set_name)
    test_set_entries_dir_list.each do |dir|
      subdirectory_path = File.join(root_path, dir)
      source_lang, target_lang = dir.split("-")
      if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
        puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
        next
      end

      puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
      source_file_content = ssh_connection.exec!("ls #{subdirectory_path}/*.#{source_lang} | xargs cat").to_s
      groundtruth_file_content = ssh_connection.exec!("ls #{subdirectory_path}/*.#{target_lang} | xargs cat").to_s
      source_file_content_io = StringIO.new(source_file_content)
      groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
      save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_file_content_io, groundtruth_file_content_io)
    end
  end
end

class ASRProcessor < SSHTaskProcessor
  def process(ssh_connection)
    task_test_set_list = ssh_connection.exec!("ls #{@root_path}").split("\n")
    task_test_set_list.each do |test_set_name|
      if test_set_name == "ACL6060"
        process_asr_task_acl6060(File.join(@root_path, test_set_name), ssh_connection)
      elsif test_set_name == "MTEDX"
        process_asr_task_mtedx(File.join(@root_path, test_set_name), ssh_connection)
      elsif test_set_name == "MUSTC"
        process_asr_task_mustc(File.join(@root_path, test_set_name), ssh_connection)
      elsif test_set_name == "DIPCO"
        process_asr_task_dipco(File.join(@root_path, test_set_name), ssh_connection)
      else
        puts "Test set #{test_set_name} not supported yet for #{@task_slug}"
      end
    end
  end

  def process_asr_task_acl6060(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set = create_or_find_test_set(test_set_name)
    source_lang = "en"
    target_lang = source_lang
    if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
      puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
      return
    end

    puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
    source_file_tgz_path = "#{root_path}/ASR__ACL6060__eval__audios.tar.gz"
    source_temp_file = Tempfile.new([ "#{test_set_name}_#{@task_slug}_#{source_lang}.tar.gz" ])
    begin
      ssh_connection.scp.download!(source_file_tgz_path, source_temp_file.path)
      groundtruth_file_content = ssh_connection.exec!("ls #{root_path}/en/ACL6060.eval.en | xargs cat").to_s

      groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
      source_temp_file_io = File.open(source_temp_file.path)
      save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
    ensure
        source_temp_file.close
        source_temp_file.unlink
    end
  end

  def process_asr_task_mtedx(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set_entries_dir_list =  ssh_connection.exec!("ls #{root_path}").split("\n")
    test_set = create_or_find_test_set(test_set_name)
    test_set_entries_dir_list.each do |dir|
      subdirectory_path = File.join(root_path, dir)
      source_lang = dir
      target_lang = source_lang
      if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
        puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
        next
      end
      puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
      source_file_tgz_path = "#{subdirectory_path}/test.#{source_lang}_audios.tar.gz"
      source_speaker_segmentation_path = "#{subdirectory_path}/test.yaml"
      main_source_file = download_and_create_tar(ssh_connection, source_file_tgz_path, source_speaker_segmentation_path, test_set_name, @task_slug, source_lang)
      # now download the source file, segmentation file, zip them together
      begin
        groundtruth_file_content = ssh_connection.exec!("ls #{root_path}/en/tst-COMMON.en | xargs cat").to_s
        groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
        source_temp_file_io = File.open(main_source_file.path)
        save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
      ensure
        main_source_file.close
        main_source_file.unlink
      end
    end
  end

  def process_asr_task_mustc(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set = create_or_find_test_set(test_set_name)
    source_lang = "en"
    target_lang = source_lang
    if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
      puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
      return
    end

    puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
    source_file_tgz_path = "#{root_path}/en/tst-COMMON.en_audios.tar.gz"
    source_speaker_segmentation_path = "#{root_path}/en/tst-COMMON.yaml"
    main_source_file = download_and_create_tar(ssh_connection, source_file_tgz_path, source_speaker_segmentation_path, test_set_name, @task_slug, source_lang)
    # now download the source file, segmentation file, zip them together
    begin
      groundtruth_file_content = ssh_connection.exec!("ls #{root_path}/en/tst-COMMON.en | xargs cat").to_s
      groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
      source_temp_file_io = File.open(main_source_file.path)
      save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
    ensure
      main_source_file.close
      main_source_file.unlink
    end
  end

  def process_asr_task_dipco(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set = create_or_find_test_set(test_set_name)
    source_lang = "en"
    target_lang = source_lang
    if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
      puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
      return
    end

    puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
    source_file_tgz_path = "#{root_path}/en/close-talk.audios.tar.gz"
    source_temp_file = Tempfile.new([ "#{test_set_name}_#{@task_slug}_#{source_lang}.tar.gz" ])
    begin
      ssh_connection.scp.download!(source_file_tgz_path, source_temp_file.path)
      groundtruth_file_content = ssh_connection.exec!("ls #{root_path}/en/close-talk.en | xargs cat").to_s

      groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
      source_temp_file_io = File.open(source_temp_file.path)
      save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
    ensure
        source_temp_file.close
        source_temp_file.unlink
    end
  end
end


class STProcessor < SSHTaskProcessor
  def process(ssh_connection)
    task_test_set_list = ssh_connection.exec!("ls #{@root_path}").split("\n")
    task_test_set_list.each do |test_set_name|
      if test_set_name == "MUSTC"
        process_st_task_mustc(File.join(@root_path, test_set_name), ssh_connection)
      elsif test_set_name == "MTEDX"
        process_st_task_mtedx(File.join(@root_path, test_set_name), ssh_connection)
      elsif test_set_name == "ACL6060"
        process_st_task_acl6060(File.join(@root_path, test_set_name), ssh_connection)
      else
        puts "Test set #{test_set_name} not supported yet for #{@task_slug}"
      end
    end
  end

  def process_st_task_mustc(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set_entries_dir_list =  ssh_connection.exec!("ls #{root_path}").split("\n")
    test_set = create_or_find_test_set(test_set_name)
    test_set_entries_dir_list.each do |dir|
      subdirectory_path = File.join(root_path, dir)
      source_lang, target_lang = dir.split("-")
      if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
        puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
        next
      end
      puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
      source_file_tgz_path = "#{subdirectory_path}/tst-COMMON.#{source_lang}-#{target_lang}_audios.tar.gz"
      source_speaker_segmentation_path = "#{subdirectory_path}/tst-COMMON.yaml"
      main_source_file = download_and_create_tar(ssh_connection, source_file_tgz_path, source_speaker_segmentation_path, test_set_name, @task_slug, source_lang)
      begin
        groundtruth_file_content = ssh_connection.exec!("ls #{subdirectory_path}/*.#{target_lang} | xargs cat").to_s
        groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
        source_temp_file_io = File.open(main_source_file.path)
        save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
      ensure
        main_source_file.close
        main_source_file.unlink
      end
    end
  end
  def process_st_task_acl6060(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set_entries_dir_list =  ssh_connection.exec!("ls #{root_path}").split("\n")
    test_set = create_or_find_test_set(test_set_name)
    already_downloaded_main_source_file = false
    source_file_tgz_path = "#{root_path}/ST__ACL6060__eval__audios.tar.gz"
    source_temp_file = Tempfile.new([ "#{test_set_name}_#{@task_slug}_en.tar.gz" ])
    source_temp_file_io = File.open(source_temp_file.path)
    begin
      test_set_entries_dir_list.each do |dir|
        next if dir.include?(".tar.gz")
        subdirectory_path = File.join(root_path, dir)
        source_lang, target_lang = dir.split("-")
        if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
          puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
          next
        end
        puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
        if not already_downloaded_main_source_file

          ssh_connection.scp.download!(source_file_tgz_path, source_temp_file.path)
          already_downloaded_main_source_file = true
        end
        groundtruth_file_content = ssh_connection.exec!("ls #{subdirectory_path}/ACL6060.eval.#{source_lang}-#{target_lang}.#{target_lang} | xargs cat").to_s
        groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
        save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
      end
    ensure
        source_temp_file.close
        source_temp_file.unlink
    end
  end
  def process_st_task_mtedx(root_path, ssh_connection)
    test_set_name = File.basename(root_path)
    test_set_entries_dir_list =  ssh_connection.exec!("ls #{root_path}").split("\n")
    test_set = create_or_find_test_set(test_set_name)
    test_set_entries_dir_list.each do |dir|
      subdirectory_path = File.join(root_path, dir)
      source_lang, target_lang = dir.split("-") # THIS IS REVERSED FOR OTHER SIMILAR SPLITS
      if test_set.entries.exists?(source_language: source_lang, target_language: target_lang)
        puts "Entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang} already exists."
        next
      end
      puts "Creating entry for #{@task_slug}/#{test_set_name} #{source_lang} to #{target_lang}"
      source_file_tgz_path = "#{subdirectory_path}/test.#{source_lang}-#{target_lang}_audios.tar.gz"
      source_speaker_segmentation_path = "#{subdirectory_path}/test.yaml"
      main_source_file = download_and_create_tar(ssh_connection, source_file_tgz_path, source_speaker_segmentation_path, test_set_name, @task_slug, source_lang)
      begin
        groundtruth_file_content = ssh_connection.exec!("ls #{root_path}/*.#{target_lang} | xargs cat").to_s
        groundtruth_file_content_io = StringIO.new(groundtruth_file_content)
        source_temp_file_io = File.open(main_source_file.path)
        save_test_set_entry_groundtruth(test_set, source_lang, target_lang, source_temp_file_io, groundtruth_file_content_io, "tar.gz", "txt")
      ensure
        main_source_file.close
        main_source_file.unlink
      end
    end
  end
end

GROUP_STORAGE_DATA_PATH = "/net/pr2/projects/plgrid/plggmeetween/tasks"
MT_PATH = File.join(GROUP_STORAGE_DATA_PATH, "MT")
ASR_PATH = File.join(GROUP_STORAGE_DATA_PATH, "ASR")
SQA_PATH = File.join(GROUP_STORAGE_DATA_PATH, "SQA")
ST_PATH = File.join(GROUP_STORAGE_DATA_PATH, "ST")
PROCESSORS_MAP = {
                  "MT" => MTProcessor.new(MT_PATH),
                  "ASR" => ASRProcessor.new(ASR_PATH),
                  "SQA" => SQAProcessor.new(SQA_PATH),
                  "ST" => STProcessor.new(ST_PATH)
                }



if Rails.env.local?
  namespace :dev do
    desc "Copy data from cluster storage and populate the database"
    task :populate, [ :user_login ] => [ :environment ] do |t, args|
      REMOTE_HOST_ADDRESS = "athena.cyfronet.pl"
      USERNAME = args[:user_login]
      Net::SSH.start(REMOTE_HOST_ADDRESS, USERNAME) do |ssh|
        # list all tasks
        task_present_in_cluster = ssh.exec!("ls #{GROUP_STORAGE_DATA_PATH}").split("\n")
        task_present_in_cluster.each do |task_slug|
          processor = PROCESSORS_MAP[task_slug]
          if processor
            processor.process(ssh)
          else
            puts "Processor for task #{task_slug} not found"
          end
        end
      end
    end
  end
end
