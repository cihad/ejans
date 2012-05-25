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
      options = args.extract_options!
      options.merge!(class: "input-xlarge")
      label_options = options.delete(:label) || {}
      label_name = label_options.delete(:name) || name
      form_item_layout do
        concat(form_label_layout { f.label name, label_name.to_s.humanize, label_options })
        concat(form_value_layout { f.send(method, name, *args, options) })
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
end