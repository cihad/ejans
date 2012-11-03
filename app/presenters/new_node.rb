class NewNode
  attr_reader :current_user, :node_type

  def initialize(node_type, current_user)
    @node_type, @current_user = node_type, current_user
  end

  def unpublished_node
    @unpublished_node ||= @current_user.unpublished_nodes(node_type).first
  end

  def any_unpublished_node?
    !!unpublished_node
  end

  def previously_saved_valid_a_node?
    current_user and any_unpublished_node? and unpublished_node.valid?
  end

  def node
    if previously_saved_valid_a_node?
      unpublished_node
    else
      saved_new_node
    end
  end

  def saved_new_node
    node = node_type.node_classify_name.constantize.new do |node|
      node.node_type_id = node_type.id
      node.author = current_user
    end
    node.save(validate: false)

    node
  end
end