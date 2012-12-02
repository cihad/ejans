module NodeTypeHelpers
  def make_full_featured_node_type
    node_type = Fabricate(:full_featured_node_type)
    make_node_view(node_type)
    make_custon_view(node_type)
    administrator = node_type.administrators.first
    [node_type, administrator]
  end
end