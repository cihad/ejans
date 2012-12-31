module ApplicationHelper
  def full_title(page_title)
    page_title.empty? ? "Ejans.com" : "#{page_title} - Ejans.com"
  end

  def page_title(title, *args)
    content_tag :h1, title, {class: "page_title"}, *args
  end

  def form_title(title)
    content_tag :legend, title
  end

  def meta_description(desc)
    meta_tag = "<meta name=\"description\" content=\""
    meta_tag += desc.truncate(160, :omission => "")
    meta_tag += "\">"
    content_for(:meta_tag) { meta_tag.html_safe }
  end

  def body_class(classes)
    content_for(:body_class) { classes }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

  def menu_item(title, path, options = {})
    data_remote = options.delete(:data_remote)
    classes = []
    classes << "data-remote" if data_remote
    classes << list_class = "active" if current_page?(path)
    options[:class] = classes.join(" ")
    content_tag :li, link_to(title, path, options), class: list_class
  end

  def merge_classes(options1 = {}, options2 = {})
    options1.merge(options2) { |k, o, n| o + " " + n }
  end

  def error_messages_for(object)
    render 'shared/error_messages', object: object
  end

  def params_query(params)
    params = params.clone
    params = params.slice!(:id, :controller, :action)
    params
  end
end
