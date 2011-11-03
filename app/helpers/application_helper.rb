module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def body_class(classes)
    content_for(:body_class) { classes }
  end

  def menu_list(text, path, method)
    if current_page?(path)
      li_class = "active"
    end
    content_tag :li, link_to(text, path, :method => method ), :class => li_class
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end
end
