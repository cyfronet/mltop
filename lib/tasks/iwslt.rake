namespace :iwslt do
  if Rails.env.local?
    task :recreate, [ "user_login" ] => [ :environment ] do |t, args|
      task("db:drop").invoke
      system "rm -rf #{File.join(Rails.root, "storage", "*/")}"

      task("db:create").invoke
      task("db:schema:load").invoke
      task("db:migrate").invoke
      task("db:seed").invoke

      TasksLoader.new(
         File.join(Rails.root, "db", "iwslt", "tasks.yml"),
         File.join(Rails.root, "db", "iwslt", "evaluators.yml")
      ).import!

      uid = ENV["UID"] || raise("Please put your keycloak UID to .env file (echo \"UID=my-uid\" >> .env)")
      User.create!(uid:, plgrid_login: "will-be-updated", provider: "plgrid",
                        email: "will@be.updated",
                        roles: [ :admin ])


      puts "DB set up complete, initializing test sets.."
      require "test_sets_loader"

      loader = TestSetsLoader.new(
        username: args.fetch(:user_login),
        remote_tasks_dir: "/net/pr2/projects/plgrid/plggmeetween/IWSLT25",
        tasks_dir: File.join(Rails.root, "tmp/IWSLT25/tasks")
      )

      loader.synchronize_with_remote!

      if TestSet.count.positive?
        puts "Test sets already in the DB, do you want to remove them and import a new one from Ares [y/n]?"
        if gets.chomp == "y"
          TestSet.destroy_all
        end
      end
      loader.import!
    end
  end

  task :synchronize, [ "user_login" ] => [ :environment ] do |t, args|
    require "test_sets_loader"

    loader = TestSetsLoader.new(
      username: args.fetch(:user_login),
      remote_tasks_dir: "/net/pr2/projects/plgrid/plggmeetween/IWSLT25",
      tasks_dir: File.join(Rails.root, "tmp/IWSLT25/tasks")
    )

    loader.synchronize_with_remote!
    loader.import!
  end
end
