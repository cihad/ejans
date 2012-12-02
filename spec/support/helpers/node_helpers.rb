module NodeHelpers
  def make_node(node_type, user)
    node = NewNode.new(node_type, user).node
    if belongs_to_config(node_type)
      make_node(belongs_to_config(node_type).parent_node_node_type, user)
    end
    node.title = valid_attributes_for(:node)["title"]
    node.fill_with_random_values
    node.publish = "Publish"
    node.statement_save
    node
  end

  def get_place_names(node_type)
    get_places(node_type).map(&:name)
  end

  def get_places(node_type)
    get_just_a_branch(place_config(node_type).top_place)
  end

  def get_just_a_branch(item)
    if item.nil?
      return
    else
      [item.children.first, get_just_a_branch(item.children.first)].compact.flatten
    end
  end

  def get_category_names(node_type)
    get_categories(node_type).map(&:name)
  end

  def get_categories(node_type)
    get_just_a_branch(tree_category_config(node_type).category)
  end

  def get_config(node_type, field_type)
    node_type.
      field_configurations.
      where("_type" => "Fields::#{field_type.classify}FieldConfiguration").
      first
  end

  Fields::FieldConfiguration.subclasses.each do |klass|
    define_method(:"#{klass.field_type}_config") do |node_type|
      get_config(node_type, klass.field_type)
    end
  end
end