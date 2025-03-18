class IwsltLoader
  HOSTNAME = "login01.ares.cyfronet.pl"
  TASKS_DIR = File.join(Rails.root, "tmp/iwslt2025_tasks")
  REMOTE_TASKS_DIR = "/net/pr2/projects/plgrid/plggmeetween/IWSLT25/tasks"

  def initialize(username:, hostname: HOSTNAME, remote_tasks_dir: REMOTE_TASKS_DIR)
    @username = username
    @hostname = hostname
    @remote_tasks_dir = remote_tasks_dir
  end

  def import!
    note "Importing tasks started"
    Task.transaction do
      Pathname.new(TASKS_DIR).children.select(&:directory?).each do |dir|
        loader = TaskLoader::Processor.for(dir)
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
