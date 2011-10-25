module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def body_class(classes)
    content_for(:body_class) { classes }
  end
end
