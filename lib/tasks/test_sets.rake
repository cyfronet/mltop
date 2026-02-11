namespace :test_sets do
  task :synchronize, [ :user_login, :challenge_id, :tasks_dir, :generate ] => [ :environment ] do |t, args|
    require "test_sets_loader"

    tasks_dir = args[:tasks_dir] || TestSetsLoader::TASKS_DIR
    generate = (args[:generate] || "false") == "true"
    if generate
      tasks_path = File.join(TestSetsLoader::FAKE_TASKS_DIR, "tasks")
      faker = TestSetFaker::TestSetsFaker.new(tasks_path)
      faker.generate

      loader = TestSetsLoader.new(challenge_id: args.fetch(:challenge_id),
                                  tasks_dir: TestSetsLoader::FAKE_TASKS_DIR)
    else
      loader = TestSetsLoader.new(username: args.fetch(:user_login),
                                  challenge_id: args.fetch(:challenge_id),
                                  tasks_dir:)
      loader.synchronize_with_remote!
    end
    if TestSet.count.positive?
      puts "Test sets already in the DB, do you want to remove them and import new ones [y/n]?"
      if gets.chomp == "y"
        TestSet.destroy_all
      end
    end
    loader.import!
  end
end
