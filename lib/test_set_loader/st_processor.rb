class TestSetLoader::StProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "ACL6060" then process_acl6060(entry)
      when "COVOST"  then process_covost(entry)
      when "MUSTC"   then process_mustc(entry)
      when "MTEDX"   then process_mtedx(entry)
      else                not_supported(entry)
      end
    end
  end

  private
    def process_mustc(dir)
      from_to_language_process(dir) do |entry, name, source, target|
        [
          archive_with_extensions(entry,
            name: "#{slug}_#{name}_#{source}.tgz",
            extensions: [ "_audios.tar.gz", "tst-COMMON.yaml" ]),
          child_with_extension(entry, ".#{target}"),
          child_with_extension(entry, ".#{source}")
        ]
      end
    end

    def process_mtedx(dir)
      from_to_language_process(dir) do |entry, name, source, target|
        [
          archive_with_extensions(entry,
            name: "#{slug}_#{name}_#{source}.tgz",
            extensions: [ "_audios.tar.gz", "test.yaml" ]),
          child_with_extension(entry, ".#{target}"),
          child_with_extension(entry, ".#{source}")
        ]
      end
    end

    def process_acl6060(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(dir, "_audios.tar.gz"),
          child_with_extension(entry, ".#{target}"),
          child_with_extension(entry, ".#{source}")
        ]
      end
    end

    def process_covost(dir)
      from_to_language_process(dir) do |entry, _name, source, target|
        [
          child_with_extension(entry, "_audios.tar.gz"),
          child_with_extension(entry, ".#{target}"),
          child_with_extension(entry, ".#{source}")
        ]
      end
    end
end
