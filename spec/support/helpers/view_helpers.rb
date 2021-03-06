module ViewHelpers
  def make_node_view(node_type)
    node_view = node_type.node_view
    node_view.user_input_node_template = user_input_node_template(node_type)
    node_view.save
  end

  def make_custom_view(node_type)
    node_type.node_type_views.build.tap do |v|
      v.user_input_node_type_template = custom_view_node_type_template
      v.user_input_node_template = custom_view_node_template(node_type)
      v.save
    end
  end

  def options_for_node_type(node_type)
    node_type.nodes_custom_fields.inject({}) do |h, field|
      h[field.type.to_sym] = field.machine_name; h
    end
  end

  def user_input_node_template(node_type)
    opts = options_for_node_type(node_type)
    mustache_render("#{Rails.root}/spec/support/templates/node_view.mustache", opts)
  end

  def custom_view_node_type_template
    opts = {}
    mustache_render("#{Rails.root}/spec/support/templates/custom_view_node_type_template.mustache", opts)
  end

  def custom_view_node_template(node_type)
    opts = options_for_node_type(node_type)
    mustache_render("#{Rails.root}/spec/support/templates/custom_view_node_template.mustache", opts)
  end
end