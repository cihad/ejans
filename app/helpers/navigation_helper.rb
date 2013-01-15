module NavigationHelper
  def tab_item(title, path, options = {})
    link_to_options = options.delete(:link_to) || {}
    options = merge_classes(options, class: "active") if current_page?(path)
    content_tag(:li, link_to(title, path, link_to_options), options)
  end

  def nav_tab(options = {}, &block)
    classes = options.delete(:class)
    render layout: 'shared/nav_tab', locals: { class: classes }, &block
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

  def column_navbar(opts = {}, &block)
    render layout: 'shared/column_navbar' do
      concat(content_tag :span, opts[:title], class: "brand") if opts.has_key?(:title)
      concat(capture(&block)) if block_given?
    end
  end
end