module NodeTypeHelpers
  def make_full_featured_node_type
    node_type = Fabricate(:full_featured_node_type)
    make_node_view(node_type)
    make_custon_view(node_type)
    super_administrator = node_type.super_administrator
    [node_type, super_administrator]
  end
end