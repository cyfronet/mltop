require "net/scp"

if Rails.env.local?
  namespace :dev do
    desc "Copy data from cluster storage and populate the database"
    task populate:, [ :user_login ] => [ :environment ] do |t, args|
      REMOTE_HOST_ADDRESS = "athena.cyfronet.pl"
      USERNAME = args[:user_login]
      GROUP_STORAGE_DATA_PATH = "/net/pr2/projects/plgrid/plggmeetween/tasks"
      Net::SSH.start(REMOTE_HOST_ADDRESS, USERNAME) do |ssh|
        TestSet.all.each do |test_set|
          test_set.tasks.each do |task|
            data_path = File.join(GROUP_STORAGE_DATA_PATH, task.slug, test_set.name)
            test_set_task_dir_list =  ssh.exec!("ls #{data_path}").split("\n")
            existing_entries_languages = test_set.entries.each.map { |entry| entry.language }
            test_set_task_dir_list.each do |dir|
              subdirectory_path = File.join(data_path, dir)
              if dir.include? "-"
                source_lang, target_lang = dir.split("-")
                target_ext = target_lang
              else
                # TODO clarify this - currently for tasks like LIPREAD and ASR the form
                # of groundtruth is heterogeneous (different for each dataset). Maybe unification will be possible
                # for now I assumed that the file with ground truth is the .yaml file
                source_lang = dir
                target_lang = source_lang
                target_ext = ".yaml"
              end
              if existing_entries_languages.exclude? source_lang
                source_file_content = ssh.exec!("ls #{subdirectory_path}/*.#{source_lang} | xargs cat").to_s
                entry = test_set.entries.create!(
                language: source_lang,
                input: { io: StringIO.new(source_file_content), filename: "entry.#{source_lang}" }
                )
                existing_entries_languages << source_lang
              else
                entry = test_set.entries.find_by(language: source_lang)
              end
              entry_extisting_groundtruth_languages = entry.groundtruths.each.map { |groundtruth| groundtruth.language }
              if entry_extisting_groundtruth_languages.exclude? target_lang
                target_file_content = ssh.exec!("ls #{subdirectory_path}/*.#{target_ext} | xargs cat").to_s
                entry.groundtruths.create!(
                  test_set_entry: entry, language: target_lang, task: task,
                  input: { io: StringIO.new(target_file_content), filename: "groundtruth_#{task.slug}.#{target_lang}" }
                )
              end
            end
          end
        end
      end
    end
  end
end
