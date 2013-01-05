class ViewLinksPresenter

  attr_reader :params
  
  def initialize(node_type_views, params, template)
    @node_type_views = node_type_views
    @params          = params
    @template        = template
  end

  def view_url(view, params)
    url_for(params.merge(view_id: view.id))
  end

  def view_link(view, params, current = false)
    link_class = "btn btn-small"
    link_class << " active" if current
    iconic_link_to(nil, view.icon, view_url(view, params), class: link_class)
  end

  def iconic_link_to(text = "", icon = "", *args)
    url = args.shift
    link_to(url, *args) do
      content_tag(:i, nil, class: icon) if icon.present?
      content_tag(:span, text) if text.present?
    end
  end

  def view_links
    node_type_views.inject("") do |output, v|
      output << view_link(v, params, v == view)
      output
    end.html_safe
  end

  def to_s
    @node_type_views.size > 1 ? view_links : "".html_safe
  end

  def method_missing(method, *args)
    @template.send(method, *args)
  end

end