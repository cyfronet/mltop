if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task :recreate, [ "user_login" ] => [ :environment ] do |t, args|
      task("db:drop").invoke
      system "rm -rf #{File.join(Rails.root, "storage", "*/")}"

      task("db:create").invoke
      task("db:schema:load").invoke
      task("db:migrate").invoke
      task("db:seed").invoke

      uid = ENV["UID"] || raise("Please put your keycloak UID to .env file (echo \"UID=my-uid\" >> .env)")
      User.create!(uid:, plgrid_login: "will-be-updated",
                        email: "will@be.updated",
                        roles: [ :admin ])


      puts "DB set up complete, initializing test sets.."
      Rake::Task["test_sets:synchronize"].invoke(args.fetch(:user_login))

      puts "Test sets created, mocking data for ST"
      Rake::Task["test_sets:mock_st"].invoke
    end
  end
end
