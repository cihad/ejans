module Views
  class NodePageView < NodeTypeView
    def view
      node_type.node_view
    end

    def rendered_node
      NodeView.new(view, node_type, nodes, node_type.conf_data, template).to_s.html_safe
    end

    def to_s
      template.render(
        inline: view.node_type_template, 
        locals: { node: rendered_node })
    end
  end
end