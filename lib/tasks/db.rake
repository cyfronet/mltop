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
end
