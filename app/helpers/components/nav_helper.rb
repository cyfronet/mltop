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
              link[:active] ? "text-orange-600" : "text-gray-500 hover:border-gray-300 hover:text-gray-700"
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

      def section(name, link, active: nil, condition: :exlusive, enabled: true)
        @sections[name] = { link:, active:, condition:, enabled: }
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
              tag.nav class: "flex items-center justify-center gap-x-16", "aria-label" => "Tabs" do
                @sections.map do |title, link|
                  concat link[:enabled] ? menu_link(title, **link) : disabled_menu_link(title, **link)
                end
              end
            end
          end

          def menu_link(title, link:, active:, condition:, **)
            active = @manual ? active : @view.is_active_link?(@view.url_for(link), condition)

            options = { class: "#{active ? "text-fuchsia-600 bg-fuchsia-100 hover:bg-fuchsia-200 font-bold" : "text-zinc-500 bg-transparent hover:bg-gray-50 font-medium"} flex-none rounded-md group relative min-w-0 flex-1 overflow-hidden py-2 px-3 text-center text-sm focus:z-10" }
            options["aria-current"] = "page" if active

            @view.link_to link, options do
              concat tag.span title
              concat tag.span class: " absolute inset-x-0 ", "aria-hidden": true
            end
          end

          def disabled_menu_link(title, **)
            tag.span title, class: "text-zinc-300 bg-transparent font-medium flex-none group relative min-w-0 flex-1 overflow-hidden py-2 px-3 text-center text-sm focus:z-10"
          end
    end
end
