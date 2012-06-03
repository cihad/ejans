module TagsHelper
  def span_with_label(content, options = {})
    classes = []
    classes << "label"
    classes << options.delete(:class)
    options[:class] = classes.join(" ")
    content_tag :span, content, options
  end

  def label_success(content)
    span_with_label(content, { class: "label-success" })
  end

  def label_info(content)
    span_with_label(content, { class: "label-info" })
  end

  def form_item_layout(*args, &block)
    content_tag :tr, *args, &block
  end

  def form_label_layout(*args, &block)
    content_tag :th, *args, &block
  end

  def form_value_layout(*args, &block)
    content_tag :td, *args, &block
  end

  %w[text_field number_field check_box text_area select].each do |method|
    define_method("simple_#{method}") do |f, name, *args|
      options                   = args.extract_options!
      %w[form_item_layout form_label_layout form_value_layout
        label input].each do |option|
          options[option.to_sym] ||= {}
      end
      classes = options[:input].delete(:class) || ""
      classes << " input-xlarge"
      options[:input][:class] = classes
      label_name                = options[:label].delete(:name) || name
      form_item_layout(options[:form_item_layout]) do
        concat(form_label_layout(options[:form_label_layout]) { f.label(name, label_name.to_s.humanize, options[:label]) })
        concat(form_value_layout(options[:form_value_layout]) { f.send(method, name, *args, options[:input]) })
      end
    end
  end

  def simple_submit(f, name = nil, *args)
    options = args.extract_options!
    classes = []
    classes << "btn" << options.delete(:class)
    options.merge!(class: classes )
    form_item_layout do
      concat(form_label_layout { "&nbsp;".html_safe })
      concat(form_value_layout { f.submit name, options })
    end
  end

  def page_title(title, *args)
    content_tag :h1, title, *args
  end

  def is_checked(f, field, options= {})
    id = f.object.class.to_s.underscore.sub("/", "_") + "_#{:filter}"
    javascript_tag "if $('##{id}').is(':checked') { $('##{id}').after('cihad') }"
  end
end