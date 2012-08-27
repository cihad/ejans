class ViewsController < ApplicationController
  before_filter :node_type, except: [:sort]
  include ControllerHelper
  

  def index
    @views = @node_type.removable_views
  end

  def new
    @view = @node_type.build_view(params)
  end

  def create
    @view = @node_type.build_view(params)
    if @view.save
      redirect_to @node_type, notice: "Succesfully."
    end
  end

  def edit
    @view = @node_type.views.find(params[:id])
  end

  def update
    @view = @node_type.views.find(params[:id])
    params_name = Views::View.param_name(params[:_type])
    if @view.update_attributes(params[params_name])
      redirect_to edit_node_type_views_view_path(@node_type, @view), notice: 'View was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @view = @node_type.views.find(params[:id])
    if @view.destroy_from_outside
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