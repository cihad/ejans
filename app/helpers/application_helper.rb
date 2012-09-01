module ApplicationHelper
  def full_title(page_title)
    page_title.empty? ? "Ejans.com" : "#{page_title} - Ejans.com"
  end

  def meta_description(desc)
    meta_tag = "<meta name=\"description\" content=\""
    meta_tag += desc.truncate(160, :omission => "")
    meta_tag += "\">"
    content_for(:meta_tag) { meta_tag.html_safe }
  end

  def conanical_url(path)
    link = "<link rel=\"canonical\" href=\""
    link += path
    link += "\">"
    content_for(:meta_tag) { link.html_safe }
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

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def count_tag(count, message = "")
    content_tag :span, "#{count} #{message}" unless count == 0
  end

  def merge_classes(options1 = {}, options2 = {})
    options1.merge(options2) { |k, o, n| o + " " + n }
  end

  def error_messages_for(object)
    render 'shared/error_messages', object: object
  end
end
