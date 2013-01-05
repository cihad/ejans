class NodeViewsController < ApplicationController

  before_filter :node_type
    
  def edit
    @node_view = @node_type.node_view
  end

  def update
    @node_view = @node_type.node_view
    if @node_view.update_attributes(params[:node_view])
      redirect_to :back, notice: t('node_views.success_update')
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
