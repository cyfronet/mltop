module Components::HeadingsHelper
  def mltop_title(title = nil, &block)
    Title.new(self, title).render
  end

  private
    class Title
      def initialize(view, title)
        @view = view
        @title = title
      end

      def render
        @view.tag.h1 @title,
          class: "mt-2 text-3xl font-bold tracking-tight sm:text-4xl mb-8 text-center"
      end
    end
end
