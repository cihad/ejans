module NodeTypesHelper
  def node_type_navigation
    nav_tab do
      render 'node_types/nav'
    end
  end

  def author_nodes_path
    node_type_nodes_path(@node.node_type, params_query(params).merge(author_id: @node.author_id.to_s))
  end
end