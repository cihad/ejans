module Views
  class NodeView
    def initialize(node, node_layout, conf_data, template)
      @node = node
      @node_layout
      @conf_data = conf_data
      @template = template
    end

    def to_s
      @template.render(inline: node_layout, locals: node.mapping(conf_datas))
    end
  end
end