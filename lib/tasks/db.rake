namespace :db do
  desc "Import records from JSON dump with ID offset"
  task import_json: :environment do
    EXPORT_DIR = Rails.root.join("export")
    BLOBS_DIR  = EXPORT_DIR.join("blobs")
    file = EXPORT_DIR.join("db_export.json")
    OFFSET = 10_000

    def deduplicate_users
      puts "Deduplicating users"
      models = { challenge: :owner_id, model: :owner_id, evaluation: :creator_id, membership: :user_id }
      User.all.group_by(&:plgrid_login).each do |login, users|
        next if login.nil?

        users.sort_by!(&:id)
        keeper = users.delete_at(0)
        users.each do |user|
          models.each do |model_name, column_name|
            model = model_name.to_s.classify.constantize
            table = model.arel_table
            model.where(table[column_name].eq(user.id)).update_all(column_name => keeper.id)
          end
          user.destroy
        end
      end
    end

    def create_memberships(challenge)
      User.where("id > ?", 10000).map do |user|
        Membership.create(challenge:, user:)
      end
    end

    data = JSON.parse(File.read(file))

    ActiveRecord::Base.transaction do
      Hypothesis.no_touching do
        iwslt = Challenge.create(name: "IWSLT", owner: User.find_by(plgrid_login: "plgkasztelnik"), starts_at: "2025-04-01".to_date.beginning_of_day,  ends_at: "2025-04-19".to_date.end_of_day)
        data.each do |model_name, records|
          model = model_name.constantize
          puts "Importing #{records.size} #{model_name} records..."

          records.each do |attrs|
            attachments = {}

            model.reflect_on_all_attachments.each do |reflection|
              name = reflection.name.to_s
              if attrs.key?(name)
                attachments[name] = attrs.delete(name)
              end
            end

            attrs["id"] = attrs["id"].to_i + OFFSET

            attrs.each do |key, value|
              if key.ends_with?("_id") && value.present?
                attrs[key] = value.to_i + OFFSET
              end
            end

            if model_name == "TestSetEntry"
              task_test_set = TaskTestSet.find_or_create_by(test_set_id: attrs.delete("test_set_id"), task_id: attrs.delete("task_id"))
              attrs.merge!({ task_test_set_id: task_test_set.id })
            end

            attrs.delete("order") if model_name == "Metric"
            attrs.merge!({ challenge_id: iwslt.id }) if model.reflect_on_association(:challenge)

            record = model.new(attrs).tap { |record| record.save(validate: false) }

            attachments.each do |name, blob_info|
              if blob_info.class == Hash
                full_path = EXPORT_DIR.join(blob_info["path"])
                record.public_send(name)
                  .attach(io: File.open(full_path),
                  filename: File.basename(full_path),
                  content_type: Marcel::MimeType.for(full_path)
                  )
              end
            end
          end
        end
        create_memberships(iwslt)
        deduplicate_users
      end
    end
    puts "✅ Import finished with offset #{OFFSET}"
  end
end
