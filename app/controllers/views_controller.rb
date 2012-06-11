class ViewsController < ApplicationController
  before_filter :node_type, except: [:sort]

  def index
    @views = @node_type.views
  end

  def new
    if Views::View::VIEW_TYPES.include?(params[:type].to_sym)
      @view = @node_type.views.build(type: params[:type])
      @view.build_assoc!
      redirect_to edit_node_type_view_path(@node_type, @view)
    else
      redirect_to @node_type, alert: "Oooooooooooops! Try again!"
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

    if @view.update_attributes(params[:view])
      redirect_to [@node_type, @view], notice: 'View was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @view = @node_type.views.find(params[:id])
    if @view.destroy
      redirect_to node_type_views_path(@node_type), notice: "Succesfully"
    end
  end

  def sort
    params[:view].each_with_index do |id, index|
      view = Views::View.find(id)
      view.update_attribute(:position, index+1)
    end
    render nothing: true
    # render :js => "console.log('')"
  end

  def feature_sort
    @view = @node_type.views.find(params[:id])
    params[:feature].each_with_index do |id, index|
      @view.features.find(id).update_attribute(:position, index+1)
    end
    render :js => "alert('Hello');"
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end
end