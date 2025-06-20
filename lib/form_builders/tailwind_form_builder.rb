module FormBuilders
  class TailwindFormBuilder < ActionView::Helpers::FormBuilder
    class_attribute :text_field_helpers,
      default: field_helpers - [ :label, :radio_button, :fields_for, :fields, :hidden_field ] + [ :rich_text_area, :text_area ]

    TEXT_FIELD_STYLE = "block w-full rounded-md border-0 py-1.5 shadow-xs ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 mt-2 dark:text-white dark:bg-inherit".freeze
    SELECT_FIELD_STYLE = "block w-full rounded-md border-0 py-1.5 shadow-xs ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:max-w-xs sm:text-sm sm:leading-6 mt-2 dark:text-white dark:bg-inherit".freeze
    SUBMIT_BUTTON_STYLE = "btn btn-primary".freeze
    LABEL_STYLE = "block text-sm font-medium leading-6".freeze
    CHECKBOX_STYLE = "h-4 w-4 rounded-sm border-zinc-300 text-fuchsia-600 hover:border-fuchsia-400 focus:border-fuchsia-600 focus:ring-0 focus:ring-offset-0 disabled:bg-zinc-200 disabled:border-0".freeze

    text_field_helpers.each do |field_method|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{field_method}(method, options = {})
            if options.delete(:tailwindified)
              super
            else
              text_like_field(#{field_method.inspect}, method, options)
            end
          end
      RUBY_EVAL
    end

    def submit(value = nil, options = {})
      custom_opts, opts = partition_custom_opts(options)
      default_styles = opts[:without_default_styles] ? "" : SUBMIT_BUTTON_STYLE
      classes = join_classes(default_styles, custom_opts[:class])

      super(value, { class: classes }.merge(opts))
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

      label = item_label(method, custom_opts[:label], options)
      field = super(method, choices, opts, html_options.merge(class: classes), &block)

      @template.content_tag "div", class: custom_opts[:wrapper] do
        label + field + error_label(method)
      end
    end

    def label(method, text = nil, options = {}, &block)
      css = [ LABEL_STYLE, options[:class] ].compact.join(" ")

      super(method, text, options.merge(class: css), &block)
    end

    def file_field(name, *args)
      field = super(name, *args)
      @template.content_tag "div" do
        field + error_label(name)
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)

      label = item_label(method, custom_opts[:label], options)
      field = super(method, collection, value_method, text_method, opts, html_options.merge(class: classes))

      @template.content_tag "div", class: custom_opts[:wrapper] do
        label + field + error_label(method)
      end
    end

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(CHECKBOX_STYLE, custom_opts, method)

      label = item_label(method, custom_opts[:label], options)
      field = super(method, collection, value_method, text_method, opts, html_options.merge(class: classes), &block)

      @template.content_tag "div", class: custom_opts[:wrapper] do
        label + error_label(method) + field
      end
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      custom_opts, opts = partition_custom_opts(options)
      classes = apply_style_classes(CHECKBOX_STYLE, custom_opts, method)

      label = @template.content_tag "span" do
        item_label(method, custom_opts[:label], options)
      end

      check = @template.content_tag "div", class: "flex items-center space-x-2" do
        super(method, opts.merge(class: classes), checked_value, unchecked_value) + label
      end

      @template.content_tag "div", class: custom_opts[:wrapper] do
        check + error_label(method)
      end
    end

    # def rich_text_area(method, options = {})
    #   custom_opts, opts = partition_custom_opts(options)
    #   classes = apply_style_classes(SELECT_FIELD_STYLE, custom_opts, method)
    #
    #   label = item_label(method, custom_opts[:label], options)
    #   field = super(method, collection, value_method, text_method, opts, html_options.merge(class: classes))
    #
    #   @template.content_tag "div", class: custom_opts[:wrapper] do
    #     label + field + error_label()
    #   end
    # end

    private

    def text_like_field(field_method, object_method, options = {})
      custom_opts, opts = partition_custom_opts(options)

      classes = apply_style_classes(TEXT_FIELD_STYLE, custom_opts, object_method)

      field = send(field_method, object_method, {
        class: classes,
        title: errors_for(object_method)&.join(" ")
      }.compact.merge(opts).merge(tailwindified: true))

      label = item_label(object_method, custom_opts[:label], options)

      @template.content_tag "div", class: custom_opts[:wrapper] do
        label + field + error_label(object_method)
      end
    end

    def item_label(object_method, label_options, field_options)
      label = tailwind_label(object_method, label_options, field_options)
      @template.content_tag("div", label, class: "flex flex-col items-start")
    end

    def tailwind_label(object_method, label_options, field_options)
      text, label_opts = if label_options.present?
        [ label_options[:text], label_options.except(:text) ]
      else
        [ nil, {} ]
      end

      label_classes = label_opts[:class] || "block text-gray-500 font-bold md:text-right mb-1 md:mb-0 pr-4"
      label_classes += " text-yellow-800 dark:text-yellow-400" if field_options[:disabled]
      label(object_method, text, {
        class: label_classes
      }.merge(label_opts.except(:class)))
    end

    def error_label(object_method, options = {})
      if errors_for(object_method).present?
        error_message = @object.errors[object_method].collect(&:titleize).join(", ")
        tailwind_label(object_method, { text: error_message, class: " font-bold text-red-500" }, options)
      end
    end

    def border_color_classes(object_method)
      if errors_for(object_method).present?
        "border-2 border-red-400 focus:border-rose-200"
      else
        "border border-gray-300 focus:border-yellow-700"
      end
    end

    def apply_style_classes(classes, custom_opts, object_method = nil)
      join_classes(classes, border_color_classes(object_method), custom_opts[:class])
    end

    def join_classes(*classes)
      classes.compact.join(" ")
    end

    CUSTOM_OPTS = [ :label, :class, :wrapper ].freeze
    def partition_custom_opts(opts)
      opts.partition { |k, v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
    end

    def errors_for(object_method)
      return unless @object.present? && object_method.present?

      @object.errors[object_method]
    end
  end
end
