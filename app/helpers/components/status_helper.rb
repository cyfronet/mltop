module Components::StatusHelper
  def mltop_status(statusable)
    Status.for(self, statusable).render
  end

  private
    class Status
      def self.for(view, statusable)
        case statusable
        when Evaluation
          RunStatus.new(view, statusable.status)
        when Challenge
          ChallengeStatus.new(view, statusable.status)
        end
      end

      def initialize(view, status)
        @view = view
        @status = status
      end

      def render
        @view.tag.div(
          class: [
            "inline-flex items-center rounded-full px-2 py-1 text-xs font-medium border",
            colors.fetch(@status, colors["failed"])
          ]
        ) do
          @view.safe_join([
            @view.tag.span(send(icons.fetch(@status, "failed"), "h-4 w-4"), class: "mr-1"),
            @view.tag.span(I18n.t("statuses.#{@status}", default: I18n.t("statuses.unknown")))
          ])
        end
      end

      def colors
        raise NotImplementedError, "#{self.class} must define #colors"
      end

      def icons
        raise NotImplementedError, "#{self.class} must define #icons"
      end
    end

    class RunStatus < Status
      include IconsHelper

      COLORS = {
        "created" => "bg-sky-50 text-sky-700 border-sky-200",
        "pending" => "bg-sky-50 text-sky-700 border-sky-200",
        "running" => "bg-lime-50 text-lime-700 border-lime-200",
        "completed" => "bg-green-50 text-green-700 border-green-200",
        "failed" => "bg-red-50 text-red-700 border-red-200"
      }

      ICONS = {
        "created" => "clock_icon",
        "pending" => "clock_icon",
        "running" => "play_icon",
        "completed" => "checked_icon",
        "failed" => "error_icon"
      }

      def colors
        COLORS
      end

      def icons
        ICONS
      end
    end
end
