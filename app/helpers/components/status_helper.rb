module Components::StatusHelper
  def mltop_run_status(statusable)
    RunStatus.new(self, statusable.status).render
  end

  private
    class RunStatus
      COLORS = {
        "created" =>   "bg-sky-50 text-sky-700 ring-sky-600/20",
        "pending" =>   "bg-sky-50 text-sky-700 ring-sky-600/20",
        "running" =>   "bg-blue-50 text-blue-700 ring-blue-600/20",
        "completed" => "bg-green-50 text-green-700 ring-green-600/20",
        "failed" =>    "bg-red-50 text-red-700 ring-red-600/20"
      }

      def initialize(view, status)
        @view = view
        @status = status
      end

      def render
      @view.tag.span I18n.t("statuses.#{@status}", default: I18n.t("statuses.unknown")),
          class: [
            "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium ring-1 ring-inset",
            COLORS.fetch(@status, COLORS["failed"])
          ]
      end
    end
end
