class NodeViewPresenter

  attr_reader :node_template, :node, :node_type

  def initialize(node_template, node, node_type)
    @node_template = node_template
    @node          = node
    @node_type     = node_type
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
    ViewRenderer.new(node_template, as_json).evaluate.gsub(/(\n|\s)+/, ' ')
  end
  
end