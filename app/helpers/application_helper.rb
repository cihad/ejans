module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
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

  def menu_list(text, path, method = "", data_remote = false)
    li_class = ""

    if current_page?(path)
      li_class = "active"
    end

    if data_remote
      li_class += " data-remote"
    end

    content_tag :li, link_to(text, path, :method => method, :class => "#{li_class}" ), :class => li_class
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

  def fade_effect(selector, speed, opacity)
    javascript_tag "$(function() {
      $(\"#{selector.to_s}\").fadeTo(\"#{speed}\", #{opacity});
      $(\"#{selector.to_s}\").hover(function(){
        $(this).fadeTo(\"#{speed}\", 1.0);
      },function(){
        $(this).fadeTo(\"#{speed}\", #{opacity});
      });
    });"
  end

  def content_count(query, message = "")
    content_tag :span, "#{query} #{message}" if query != 0
  end
end
