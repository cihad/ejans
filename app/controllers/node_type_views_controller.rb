class NodeTypeViewsController < ApplicationController
  include ControllerHelper

  before_filter :node_type

  layout "small"

  def index
    @node_type_views = @node_type.node_type_views
  end

  def new
    @node_type_view = @node_type.node_type_views.new
  end

  def create
    @node_type_view = @node_type.node_type_views.new(params[:node_type_view])
    if @node_type_view.save
      redirect_to @node_type, notice: "Succesfully."
    else
      render action: :new
    end
  end

  def edit
    @node_type_view = @node_type.node_type_views.find(params[:id])
  end

  def update
    @node_type_view = @node_type.node_type_views.find(params[:id])
    if @node_type_view.update_attributes(params[:node_type_view])
      redirect_to edit_node_type_node_type_view_path(@node_type, @node_type_view),
        notice: 'View was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @node_type_view = @node_type.node_type_views.find(params[:id])
    if @node_type_view.destroy
      redirect_to node_type_node_type_views_path(@node_type), notice: "Succesfully"
    end
  end

  def sort
    sort_fields params[:node_type_view], @node_type.node_type_views
  end

private

  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def current_resource
    @current_resource = node_type if params[:node_type_id]
  end

end
