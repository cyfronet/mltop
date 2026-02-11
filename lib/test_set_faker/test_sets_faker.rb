class TestSetFaker::TestSetsFaker
  def initialize(tasks_path)
    @tasks_path = tasks_path
  end

  def generate
    note "Creating mirrored structure without downloading files"
    FileUtils.rm_rf(@tasks_path)
    FileUtils.mkdir_p(@tasks_path)
    task_dirs = [ "ST", "MT", "ASR", "SUM", "SSUM", "SQA", "SLU", "LIPREAD", "TTS" ]

    task_dirs.each do |task_name|
      faker_class = self.class.for(task_name)
      faker = faker_class.new(@tasks_path, task_name)
      faker.generate
    end
    note "Mirrored structure created successfully"
  end

  def self.for(task_name)
    case task_name.upcase
    when "ST" then TestSetFaker::StFaker
    when "MT" then TestSetFaker::MtFaker
    when "ASR" then TestSetFaker::AsrFaker
    when "SUM" then TestSetFaker::SumFaker
    when "SSUM" then TestSetFaker::SsumFaker
    when "SQA" then TestSetFaker::SqaFaker
    when "SLU" then TestSetFaker::SluFaker
    when "LIPREAD" then TestSetFaker::LipreadFaker
    when "TTS" then TestSetFaker::TtsFaker
    else TestSetFaker::UnknownFaker
    end
  end

  private

    def note(msg)
      puts "\e[#{34}m#{msg}\e[0m"
    end
end

require "test_set_faker/base_faker"
require "test_set_faker/unknown_faker"
require "test_set_faker/st_faker"
require "test_set_faker/mt_faker"
require "test_set_faker/asr_faker"
require "test_set_faker/sum_faker"
require "test_set_faker/ssum_faker"
require "test_set_faker/sqa_faker"
require "test_set_faker/slu_faker"
require "test_set_faker/lipread_faker"
require "test_set_faker/tts_faker"
require "test_set_faker/test_sets_faker"
