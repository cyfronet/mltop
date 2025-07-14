class TestSetLoader::UnknownProcessor < TestSetLoader::Processor
  def import!
    error "Unable to import #{slug} - processor unknown"
  end
end
