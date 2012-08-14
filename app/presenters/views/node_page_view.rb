module Views
  class NodePageView < NodeTypeView
    def view
      node_type.views.select { |view| view._type == Views::Node }
    end

    def node_layout
      %q{
        <div class='node' id='node-#{node.id}'>
          <%= nodes %>
        </div>
      }
    end

    def rendered_node
      NodeView.new(view, node_type, nodes, node_type.conf_data, template).to_s.html_safe
    end

    def to_s
      template.render(
        inline: node_layout, 
        locals: { nodes: rendered_node })
    end
  end
end