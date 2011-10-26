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
end
