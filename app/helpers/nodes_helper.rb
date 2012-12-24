module NodesHelper

  def link_to_change_status(node, event)
    link_to t("nodes.#{event}"),
      change_status_node_type_node_path(@node_type, node, event: event),
      class: "btn btn-mini"
  end
end