module NodeTypesHelper
  def node_type_navigation
    content_tag :ul, class: "nav pull-right" do
      render 'node_types/nav'
    end
  end

  def author_nodes_path
    node_type_nodes_path(@node.node_type_id, params_query(params).merge(author_id: @node.author_id))
  end
end