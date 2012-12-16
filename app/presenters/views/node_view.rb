module Views
  class NodeView
    attr_reader :view, :node, :node_type, :field_data, :template

    def initialize(view, node_type, node, field_data, template)
      @view = view
      @node_type = node_type
      @node = node
      @field_data = field_data
      @template = template
    end

    def node_template
      view.node_template
    end

    def locals
      node.mapping(field_data)
    end

    def to_s
      @template.render(inline: node_template, locals: locals)
    end
  end
end