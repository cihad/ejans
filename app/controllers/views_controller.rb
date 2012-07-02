class ViewsController < ApplicationController
  before_filter :node_type, except: [:sort]
  include ControllerHelper
  

  def index
    @views = @node_type.views
  end

  def new
    @view = @node_type.views.build(params[:views_view])
    @view.build_assoc!
    if @view.save
      redirect_to edit_node_type_views_view_path(@node_type, @view)
    else
      redirect_to node_type_views_views_path(@node_type)
    end
  end

  def create
    @view = @node_type.views.build(params[:views_view])
    if @view.save
      redirect_to @node_type, notice: "Succesfully."
    end
  end

  def edit
    @view = @node_type.views.find(params[:id])
  end

  def update
    @view = @node_type.views.find(params[:id])
    if @view.update_attributes(params[:views_view])
      redirect_to edit_node_type_views_view_path(@node_type, @view), notice: 'View was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @view = @node_type.views.find(params[:id])
    if @view.destroy
      redirect_to node_type_views_views_path(@node_type), notice: "Succesfully"
    end
  end

  def sort
    sort_fields params[:view], Views::View
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end
end