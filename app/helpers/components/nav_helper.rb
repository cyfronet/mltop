module Components::NavHelper
  def mltop_navlinks(&block)
    nav_links = NavLinks.new(self)
    block.call(nav_links)

    nav_links.render
  end

  def mltop_nav(manual: false, &block)
    nav = Nav.new(self, manual)
    block.call(nav)

    nav.render
  end

  private
    class NavLinks
      def initialize(view)
        @view = view
        @links = []
      end

      def add(name, url, condition = :exclusive)
        @links << { name:, url:, active: active?(url, condition) }
      end

      def render
        @view.capture do
          @links.map do |link|
            css = [
              "inline-flex items-center px-1 pt-1 text-sm font-medium",
              link[:active] ? "text-gray-900" : "text-gray-500 hover:border-gray-300 hover:text-gray-700"
            ].join(" ")

            @view.concat @view.link_to(link[:name], link[:url], class: css)
          end
        end
      end

      private
        def active?(link, condition)
          @view.is_active_link?(@view.url_for(link), condition)
        end
    end

    class Nav
      def initialize(view, manual = false)
        @view = view
        @manual = manual
        @sections = {}
      end

      def section(name, link, active: nil, condition: :exlusive)
        @sections[name] = { link:, active:, condition: }
      end

      def render
        @view.capture do
          concat mobile_menu
          concat menu
        end
      end

      private
        delegate :tag, :concat, to: :@view

        private
          def mobile_menu
            # TODO: https://tailwindui.com/components/application-ui/navigation/tabs#component-83b472fc38b57e49a566805a5e5bb2f7
          end

          def menu
            tag.div class: "block" do
              tag.nav class: "isolate flex divide-x divide-gray-200 rounded-lg shadow", "aria-label" => "Tabs" do
                @sections.map do |title, link|
                  concat menu_link(title, **link)
                end
              end
            end
          end

          def menu_link(title, link:, active:, condition:)
            active = @manual ? active : @view.is_active_link?(@view.url_for(link), condition)

            options = { class: "text-gray-#{active ? 900 : 500} group relative min-w-0 flex-1 overflow-hidden bg-gray-50 py-4 px-4 text-center text-sm font-medium hover:bg-gray-50 focus:z-10" }
            options["aria-current"] = "page" if active

            @view.link_to link, options do
              concat tag.span title
              concat tag.span class: "#{active ? "bg-indigo-500" : "bg-transparent"} absolute inset-x-0 bottom-0 h-0.5", "aria-hidden": true
            end
          end
    end
end
