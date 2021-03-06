module TagsHelper
  def span_with_label(content, options = {})
    classes = [] << "label" << options.delete(:class)
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
    options = args.extract_options!

    options.has_key?(:class) ?
      options[:class] += " label-field" :
      options[:class] = "label-field"

    content_tag :th, options, *args, &block
  end

  def form_value_layout(*args, &block)
    content_tag :td, *args, &block
  end

  %w[text_field number_field email_field check_box text_area select
      collection_select, password_field].each do |method|
    define_method("simple_#{method}") do |f, name, *args|

      options = args.extract_options!

      %w[form_item_layout
        form_label_layout
        form_value_layout
        label
        input].each do |option|
          options[option.to_sym] ||= {}
      end

      help = options.delete(:help)

      classes = [] << (options[:input].delete(:class) || "")
      classes << "input-xlarge"
      options[:input][:class] = classes.join(" ")

      label_name = options[:label].delete(:name) || name

      form_item_layout(options[:form_item_layout]) do
        concat(
          form_label_layout(options[:form_label_layout]) do
            f.label(name, label_name, options[:label])
          end
        )
        
        concat(
          form_value_layout(options[:form_value_layout]) do
            concat(f.send(method.to_sym, name, *args, options[:input]))
            concat(content_tag(:p, help, class: "help"))
          end
        )
      end
    end
  end

  def simple_submit(f, name = nil, *args)
    options = args.extract_options!
    classes = [] << "btn" << options.delete(:class)
    options.merge!(class: classes )
    form_item_layout do
      concat(form_label_layout { "&nbsp;".html_safe })
      concat(form_value_layout { f.submit name, options })
    end
  end

  def checkbox_group(label, &block)
    form_item_layout do
      concat(form_label_layout { label_tag label })
      concat(form_value_layout(&block))
    end
  end

  def checkbox(f, obj_id, obj_label)
    concat(f.checkbox obj_id)
    concat(obj_label)
  end
end