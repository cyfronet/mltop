class TestSetFaker::UnknownFaker < TestSetFaker::BaseFaker
  def generate
    error "Unable to create structure for unknown task - faker unknown"
  end

  private

    def error(msg)
      puts "\e[#{31}m  - #{msg}\e[0m"
      raise "Unknown task faker: #{msg}"
    end
end
