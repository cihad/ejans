module NodeHelpers
  def make_node(node_type, user)
    if belongs_to_field(node_type)
      make_node(NodeType.class_name_to_node_type(belongs_to_field(node_type).class_name), user)
    end
    node = NewNode.new(node_type, user).node.tap do |n|
      n.title = valid_attributes_for(:node)["title"]
      n.fill_with_random_values
      n.save
    end
  end

  def get_place_names(node_type)
    get_places(node_type).map(&:name)
  end

  def get_places(node_type)
    get_just_a_branch(place_field(node_type).top_place)
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
    get_just_a_branch(tree_category_field(node_type).category)
  end

  def get_field(node_type, type)
    node_type.
      nodes_custom_fields.
      where("_type" => "CustomFields::Fields::#{type.classify}::Field").
      first
  end

  ::CustomFields::Fields::Default::Field.subclasses.each do |klass|
    define_method(:"#{klass.type}_field") do |node_type|
      get_field(node_type, klass.type)
    end
  end
end