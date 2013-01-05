class NodeViewPresenter

  def initialize(node_template, node, data, template)
    @node_template = node_template
    @node          = node
    @data          = data
    @template      = template
  end

  def locals
    @node.mapping(@data)
  end

  def to_s
    @template.render inline: @node_template, locals: locals
  end
  
end