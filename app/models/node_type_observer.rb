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

private
  
  def destroy_all_metadata(node_type)
    Metadata.where(document: node_type).destroy
  end

  def create_metadata(node_type)
    node_type.searchables.each do |tag|
      Metadata.create(text: tag, document: node_type)
    end
  end
end