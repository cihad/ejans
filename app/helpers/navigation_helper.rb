module NavigationHelper
  def tab_item(title, path, options = {})
    link_to_options = options.delete(:link_to) || {}
    options = merge_classes(options, class: "active") if current_page?(path)
    content_tag(:li, link_to(title, path, link_to_options), options)
  end

  def nav_tab(options = {}, &block)
    type = options.delete(:type) || "nav-tabs"
    render layout: 'shared/nav_tab', locals: { type: type }, &block
  end

  def dropdown_tab(title, options = {}, &block)
    urls = Nokogiri::HTML(capture(&block)).css('a')
    urls = urls.map do |url|
            url.attributes["href"].value unless url.attributes["data-method"].try(:value) == "delete"
          end
    urls.compact!
    active = urls.any? { |url| current_page?(url_for(url)) }
    render layout: 'shared/dropdown_nav_item', locals: { title: title, active: active }, &block
  end

  def dropdown(title, options = {}, &block)
    direction = options.delete(:direction) || ""
    classes = options.delete(:class) || ""
    locals = {
      title: title,
      direction: direction,
      classes: classes
    }.merge(options)
    render layout: 'shared/dropdown', locals: locals, &block
  end
end