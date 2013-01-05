class NodeTypeViewPresenter

  attr_reader :node_type, :nodes, :template, :params

  def initialize(node_type, nodes, params, template)
    @template   = template
    @node_type  = node_type
    @nodes      = nodes
    @params     = params
    yield self if block_given?
  end

  delegate :css, :js, :node_template, :node_type_template, to: :view

  alias :h :template

  def rendered_css
    h.content_tag :style, css, type: Mime::CSS
  end

  def rendered_js
    h.javascript_tag js
  end

  def to_s
    template.render inline: node_type_template, locals: { nodes: rendered_nodes }
  end

  def paginate
    @template.paginate nodes
  end

  def view_links
    ViewLinksPresenter.new(node_type.node_type_views, params, h).to_s
  end

  def sort_links
    SortLinksPresenter.new(node_type.sort_data, params, h).to_s
  end

private
  
  def view
    view_id = params[:view_id]
    @view ||= if view_id.present? 
                node_type_views.find(params[:view_id])
              elsif node_type_views.present?
                node_type_views.first
              else
                DefaultNodeTypeView.new(node_type)
              end
  end

  def node_type_views
    @node_type_views ||= node_type.node_type_views
  end

  def rendered_nodes
    nodes.inject("") do |out, node|
      out << NodeViewPresenter.new(node_template, node, node_type.field_data, template).to_s
    end.html_safe
  end

end