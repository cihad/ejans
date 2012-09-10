class NodeLoad
  def self.find(id)
    node = Node.find(id)
    raise unless node.node_type
    node.build_assoc!
    node
  end
end