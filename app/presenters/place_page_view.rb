class PlacePageView
  attr_reader :place

  def initialize(place, template)
    @place = place
    @template = template
  end

  def nodes
    @nodes ||= place.nodes
  end

  def node_type_template
    @node_type_template ||= Views::PlacePage.node_type_template
  end

  def rendered_nodes
    return nodes.inject("") do |str, node|
      node_type = node.node_type
      view = node_type.place_page_view
      conf_data = node_type.conf_data
      str << @template.render(inline: node_type_template,
                              locals: {
                                node: Views::NodeView.new(view, node_type, node, conf_data, @template).to_s,
                                url: @template.node_type_node_path(node_type, node)
                               })
      str
    end.html_safe
  end

  def to_s
    @template.render(
      inline: place_page_template,
      locals: { nodes: rendered_nodes })
  end

  def place_page_template
    @place_page_template ||= Views::PlacePage.place_page_template
  end

end