if Rails.env.local?
  require "task_loader"

  namespace :dev do
    task :populate, [ :user_login ] => [ :environment ] do |t, args|
      loader = TaskLoader.new(username: "plgkasztelnik")

      if loader.tasks_downloaded?
        puts "Test sets directory already exists - do you want to fetch it from Athena once again [y/n]?"
        if gets.chomp == "y"
          loader.cleanup!
          loader.fetch_tasks!
        end
      else
        loader.fetch_tasks!
      end

      if TestSet.count.positive?
        puts "Test sets already in the DB, do you want to remove them and import a new one from Ares [y/n]?"
        if gets.chomp == "y"
          TestSet.destroy_all
        end
      end
      loader.import!
    end
  end
end
