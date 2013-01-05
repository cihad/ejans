class PlacePageViewController < ApplicationController
  
  before_filter :node_type

  def edit
    @view = @node_type.place_page_view
  end

  def update
    @view = @node_type.place_page_view
    if @view.update_attributes(params[:place_page_view])
      redirect_to edit_node_type_place_page_view_path(@node_type),
        notice: 'View was successfully updated.'
    else
      render action: "edit"
    end
  end

private

  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def current_resource
    @current_resource = node_type if params[:node_type_id]
  end
end
