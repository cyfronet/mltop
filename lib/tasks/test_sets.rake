namespace :test_sets do
  task :synchronize, [ :user_login ] => [ :environment ] do |t, args|
    require "test_sets_loader"

    loader = TestSetsLoader.new(username: args.fetch(:user_login))

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
