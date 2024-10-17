class TaskLoader::UnknownProcessor < TaskLoader::Processor
  def import!
    error "Unable to import #{dir.basename} - processor unknown"
  end
end
