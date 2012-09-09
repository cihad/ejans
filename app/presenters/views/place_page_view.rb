module Views
  class PlacePageView
    attr_reader :place

    def initialize(place, template)
      @place = place
      @template = template
    end

    def node_type_template
      view.node_type_template
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
                                locals: { nodes: Views::NodeView.new(view, node_type, node, conf_data, @template).to_s })
        str
      end.html_safe
    end

    def to_s
      @template.render(
        inline: place_page_template,
        locals: { nodes: rendered_nodes })
    end

    def place_page_template
       %q{<div class="row">
          <div id="masonry-view">
            <%= nodes %>
          </div>
        </div>}
    end
  end
end