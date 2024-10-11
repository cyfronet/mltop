if Rails.env.local?
  require "task_loader"

  namespace :dev do
    task :populate, [ :user_login ] => [ :environment ] do |t, args|
      loader = TaskLoader.new(username: args.fetch(:user_login))

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
end
