class ViewPresenter
  attr_accessor :params, :node_type, :view, :nodes
  attr_reader :node_type_layout, :node_layout

  def initialize(params = {}, node_type, nodes, template)
    self.params = params
    @template = template
    self.node_type = node_type
    self.view = params[:view_id]
    self.nodes = nodes
  end

  def view=(view_id)
    @view = if view_id
              node_type.views.find(view_id)
            else
              default_view
            end
    @node_type_layout = @view.node_type_layout || ""
    @node_layout = @view.node_layout || ""
  end

  def default_view
    node_type.views.first
  end

  def to_s
    @template.render(inline: node_type_layout, locals: { nodes: rendered_nodes })
  end

  def rendered_nodes
    conf_datas = node_type.conf_datas
    rendered = nodes.inject("") do |str, node|
      str << @template.render(inline: node_layout, locals: node.mapping(conf_datas))
    end.html_safe
    rendered
  end

  def css
    @template.content_tag :style, view.css, type: Mime::CSS
  end

  def js
    @template.javascript_tag view.js
  end

  def paginate
    @template.paginate nodes
  end

  def view_links
    params.delete(:node_id)
    if node_type.views.count > 1
      links = node_type.views.inject("") do |output, v|
                current_class = "active" if v == view
                output += @template.link_to @template.url_for(params.merge(view_id: v.id.to_s)), class: "btn data-remote #{current_class}" do
                  @template.content_tag :i, nil, class: "icon-th-large"
                end
                output
              end
      links.html_safe
    end
  end
end