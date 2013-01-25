class NodeViewPresenter

  attr_reader :node_template, :node, :node_type, :context

  def initialize(node_template, node, node_type, context)
    @node_template = node_template
    @node          = node
    @node_type     = node_type
    @context       = context
  end

  alias :h :context

  def path
    h.node_type_node_path(node.node_type_id, node.id)
  end

  def field_data
    @field_data ||= node_type.field_data
  end

  def node_data
    { node: node }
  end

  def as_json
    field_data.merge(node_data).merge(node_type.self_data)
  end

  def to_s
    ViewRenderer.new(node_template, as_json).evaluate
  end
  
end