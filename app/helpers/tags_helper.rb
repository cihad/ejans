module TagsHelper
  def span_with_label(content, options = {})
    classes = []
    classes = "label"
    classes << options.delete(:class)
    options[:class] = classes
    content_tag :span, content, options
  end

  def label_success(content)
    span_with_label(content, { class: "label-success" })
  end

  def label_info(content)
    span_with_label(content, { class: "label-info" })
  end
end