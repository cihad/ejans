class NodeBinding
  def initialize(node, data)
    node.mapping(data).each do |parse|
      instance_variable_set(parse.first, parse.last)
    end
  end

  def get_binding
    binding
  end
end