class TestSetsLoader
  HOSTNAME = "login01.ares.cyfronet.pl"
  TASKS_DIR = File.join(Rails.root, "tmp/tasks")
  REMOTE_TASKS_DIR = "/net/pr2/projects/plgrid/plggmeetween/tasks"

  def initialize(username:, challenge_id:, hostname: HOSTNAME, remote_tasks_dir: REMOTE_TASKS_DIR, tasks_dir: TASKS_DIR)
    @username = username
    @challenge_id = challenge_id
    @hostname = hostname
    @remote_tasks_dir = remote_tasks_dir
    @tasks_dir = tasks_dir
  end

  def import!
    note "Importing tasks started"
    Task.transaction do
      Pathname.new(@tasks_dir).children.select(&:directory?).each do |dir|
        loader = TestSetLoader::Processor.for(dir, @challenge_id)
        note "Importing #{dir.basename} using #{loader.class}"

        loader.import!
      end
    end
    note "Importing tasks finished"
  end

  def synchronize_with_remote!
    note "Synchronizing with #{@username}@#{@hostname}:#{@remote_tasks_dir}"
    system "rsync -avzh #{@username}@#{@hostname}:#{@remote_tasks_dir} #{File.join(Rails.root, "tmp")}"
  end

  private
    def path(local)
      File.join Rails.root, local
    end

    def note(msg)
      puts "\e[#{34}m#{msg}\e[0m"
    end
end

require "test_set_loader/processor"
require "test_set_loader/mt_processor"
require "test_set_loader/asr_processor"
require "test_set_loader/sqa_processor"
require "test_set_loader/st_processor"
require "test_set_loader/sum_processor"
require "test_set_loader/ssum_processor"
require "test_set_loader/unknown_processor"
