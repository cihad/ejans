class NodeTypeViewPresenter

  attr_reader :node_type, :nodes, :context, :params

  def initialize(node_type, nodes, params, context)
    @context    = context
    @node_type  = node_type
    @nodes      = nodes
    @params     = params
    yield self if block_given?
  end

  delegate :css, :js, :node_template, :node_type_template, to: :view
  delegate :name, :filtered_fields, to: :node_type

  alias :h :context

  def partial_path(partial_name)
    "nodes/index_partials/#{partial_name}"
  end

  def rendered_css
    h.content_tag :style, css, type: Mime::CSS
  end

  def rendered_js
    h.javascript_tag js
  end

  def to_s
    ViewRenderer.new(node_type_template, nodes: rendered_nodes).evaluate.html_safe
  end

  def paginate
    h.paginate nodes
  end

  def view_links
    ViewLinksPresenter.new(node_type.node_type_views, params, h).to_s
  end

  def sort_links
    SortLinksPresenter.new(node_type.sort_data, params, h).to_s
  end

  def page_title
    name
  end

  def add_new_node_link
    h.render partial_path('add_node_link')
  end

  def related_node_types
    h.render partial_path('related_node_types')
  end

  def one_or_more_filters?
    !filtered_fields.blank?
  end

  def filters
    h.render partial_path('filters'), view: self
  end

private
  
  def view
    @view ||= CurrentView.new(node_type, params[:view_id]).view
  end

  def node_type_views
    @node_type_views ||= node_type.node_type_views
  end

  def rendered_nodes
    nodes.inject("") do |out, node|
      out << node["view_#{view.id}"]
    end
  end

end