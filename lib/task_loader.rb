
class TaskLoader
  HOSTNAME = "login01.ares.cyfronet.pl"
  TASKS_DIR = File.join(Rails.root, "tmp/tasks")

  REMOTE_TASKS_DIR = "/net/pr2/projects/plgrid/plggmeetween/tasks"

  include SSHKit::DSL

  def initialize(username:, hostname: HOSTNAME)
    @username = username
    @hostname = hostname
  end

  def cleanup!
    Pathname.new(TASKS_DIR).rmtree
  end

  def tasks_downloaded?
    File.exist?(TASKS_DIR)
  end

  def import!
    puts "Importing tasks started"
    Task.transaction do
      Pathname.new(TASKS_DIR).children.select(&:directory?).each do |dir|
        loader = TaskLoader::Processor.for(dir)
        puts "Importing #{dir.basename} using #{loader.class}"

        loader.import!
      end
    end
    puts "Importing tasks finished"
  end

  def fetch_tasks!
    on host do
      download! REMOTE_TASKS_DIR, File.join(Rails.root, "tmp"), recursive: true
    end
  end

  private
    def host
      SSHKit::Host.new(hostname: @hostname, ssh_options: { user: @username })
    end

    def path(local)
      File.join Rails.root, local
    end
end

require "task_loader/processor"
require "task_loader/mt_processor"
require "task_loader/asr_processor"
require "task_loader/sqa_processor"
require "task_loader/st_processor"
require "task_loader/unknown_processor"
require "task_loader/unknown_processor"
