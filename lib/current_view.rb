class CurrentView

  def initialize(node_type, requested_view_id = nil)
    @node_type = node_type
    @requested_view_id = requested_view_id
  end

  def view
    views.where(@requested_view_id).first ||
    views.first ||
    DefaultNodeTypeView.new
  end

  private

  def views
    @views ||= @node_type.node_type_views
  end

end