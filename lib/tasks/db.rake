namespace :db do
  task dump_to_json: :environment do
    EXPORT_DIR = Rails.root.join("export")
    BLOBS_DIR  = EXPORT_DIR.join("blobs")
    FileUtils.mkdir_p(BLOBS_DIR)

    def models_to_export
      [ User,
      TestSet,
      Evaluator,
      Model,
      Task,
      TaskTestSet,
      TaskModel,
      TaskEvaluator,
      TestSetEntry,
      Metric,
      Hypothesis,
      Evaluation,
      Score
    ]
    end

    def save_blob(blob)
      blob_path = BLOBS_DIR.join("#{blob.id}_#{blob.filename}")
      File.open(blob_path, "wb") { |f| f.write(blob.download) }
      { id: blob.id, path: blob_path.relative_path_from(EXPORT_DIR).to_s }
    end

    def save_attachments(record, attachment_names)
      result = {}
      attachment_names.each do |attachment_name|
        attachment = record.send(attachment_name)
        if attachment.class == ActiveStorage::Attached::One
          blob = attachment.blob
          next unless blob
          result[attachment.name] = save_blob(blob)
        else
          blobs = attachment.blobs
          next if blobs.empty?

          result[attachment.name] = blobs.map { |blob| save_blob(blob) }
        end
      end
      result
    end

    def rich_text_attributes(record, rich_text_names)
      rich_text_names.each_with_object({}) do |rich_text_name, hash|
        hash[rich_text_name] = record.send(rich_text_name)&.body
      end
    end

    data = {}
    Rails.application.eager_load!
    models_to_export.each do |model|
      puts "Exporting #{model.name}..."

      attachment_names = model.reflect_on_all_attachments.map(&:name)
      rich_text_names = model.rich_text_association_names.map { |name| name.to_s.delete_prefix("rich_text_").to_sym }
      records = model.all.map do |record|
        attrs = record.attributes
        attrs.merge!(save_attachments(record, attachment_names)) if attachment_names
        attrs.merge!(rich_text_attributes(record, rich_text_names)) if rich_text_names
        attrs
      end

      data[model.name] = records
    end

    # Write everything to a single YAML file
    File.open(EXPORT_DIR.join("db_export.json"), "w") do |f|
      f.write(data.to_json)
    end

    puts "✅ Export finished. Files are in #{EXPORT_DIR}"
  end

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

    data = JSON.parse(File.read(file))

    ActiveRecord::Base.transaction do
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
      deduplicate_users
    end
    puts "✅ Import finished with offset #{OFFSET}"
  end
end
