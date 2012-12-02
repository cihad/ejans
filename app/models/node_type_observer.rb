class NodeTypeObserver < Mongoid::Observer
  def after_create(node_type)
    create_metadata(node_type)
  end

  def after_update(node_type)
    destroy_all_metadata(node_type)
    create_metadata(node_type)
  end

  def before_save(node_type)
    node_type.nodes_count = node_type.nodes.count
  end

  def after_save(node_type)
    update_node_type_class(node_type)
  end

  private
  def update_node_type_class(node_type)
    if node_type.name_changed?
      node_type.nodes.each do |node|
        node._type = node_type.node_classify_name
        node.save(validate: false)
      end
    end
  end
  
  def destroy_all_metadata(node_type)
    Metadata.where(document: node_type).destroy
  end

  def create_metadata(node_type)
    node_type.searchables.each do |tag|
      Metadata.create(text: tag, document: node_type)
    end
  end
end