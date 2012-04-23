module TagsHelper
  def label(content, options = {})
    classes = []
    classes = "label"
    classes << options.delete(:class)
    options[:class] = classes
    content_tag :span, content, options
  end

  def label_success(content)
    label(content, { class: "label-success" })
  end

  def label_info(content)
    label(content, { class: "label-info" })
  end
end