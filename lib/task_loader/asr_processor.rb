class TaskLoader::AsrProcessor < TaskLoader::Processor
  def import!
    dir.each_child do |entry|
      next if entry.file?

      case entry.basename.to_s
      when "ACL6060" then process_acl6060(entry)
      when "MTEDX"    then process_mtedx(entry)
      when "MUSTC"    then process_mustc(entry)
      when "DIPCO"    then process_dipco(entry)
      else                 not_supported(entry)
      end
    end
  end

  private
    def process_acl6060(dir)
      single_language_process(dir) do |entry, _name, lang|
        [
          child_with_extension(dir, "audios.tar.gz"),
          child_with_extension(entry, "eval.#{lang}")
        ]
      end
    end

    def process_mtedx(dir)
      single_language_process(dir) do |entry, name, lang|
        [
          archive_with_extensions(entry,
            name: "#{slug}_#{name}_#{lang}.tgz",
            extensions: [ "_audios.tar.gz", "test.yaml" ]),
          child_with_extension(entry, "test.#{lang}")
        ]
      end
    end

    def process_mustc(dir)
      single_language_process(dir) do |entry, name, lang|
        [
          archive_with_extensions(entry,
            name: "#{slug}_#{name}_#{lang}.tgz",
            extensions: [ "_audios.tar.gz", "tst-COMMON.yaml" ]),
          child_with_extension(entry, "tst-COMMON.#{lang}")
        ]
      end
    end

    def process_dipco(dir)
      single_language_process(dir) do |entry, _name, lang|
        [
          child_with_extension(entry, "close-talk.audios.tar.gz"),
          child_with_extension(entry, "close-talk.#{lang}")
        ]
      end
    end
end
