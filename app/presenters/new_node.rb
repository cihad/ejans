class NewNode
  attr_reader :current_user, :node_type
  attr_accessor :node

  def initialize(node_type, current_user)
    @node_type, @current_user = node_type, current_user
  end

  def any_unpublished_node?
    !!unpublished_node
  end

  def previously_saved_valid_a_node?
    current_user and any_unpublished_node? and unpublished_node.valid?
  end

  def node
    set_node
    @node
  end

  # private
  def set_node
    previously_saved_valid_a_node? ? unpublished_node : saved_new_node
  end

  def saved_new_node
    destroy_old_nodes
    
    self.node = node_type.nodes.build({}, node_type.node_classify_name.constantize) do |n|
      n.node_type = node_type
      n.author = current_user
      n.save validate: false
    end
  end

  def unpublished_node
    self.node = current_user.unpublished_nodes(node_type).first
  end

  def destroy_old_nodes
    if current_user and (nodes = current_user.nodes.where(node_type_id: node_type.id) and nodes.exists?)
      nodes.destroy_all
    end
  end
end