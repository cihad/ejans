class NewNode
  attr_reader :current_user, :node_type

  def initialize(node_type, current_user)
    @node_type, @current_user = node_type, current_user
  end

  def node
    node_type.nodes.build.tap do |n|
      n.author = current_user
      n.save validate: false
    end
  end
end