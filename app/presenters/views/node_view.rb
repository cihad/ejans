module Views
  class NodeView
    attr_reader :view, :node, :node_type, :conf_data, :template

    def initialize(view, node_type, node, conf_data, template)
      @view = view
      @node_type = node_type
      @node = node
      @conf_data = conf_data
      @template = template
    end

    def node_layout
      view.node_layout
    end

    def locals
      node.mapping(conf_data)
    end

    def to_s
      @template.render(inline: node_layout, locals: locals)
    end
  end
end