class PlacesController < ApplicationController
  before_filter :should_be_admin, only: [:index, :create, :edit, :update, :destroy]
  respond_to :js, only: [:index]
  layout 'small', only: [:index]
  

  def show
    @place = Place.find(params[:id])
  end

  def index
    @items = Place.roots
    @event = params[:event] if params[:event]
    case @event
    when "show"
      @parent_item = Place.find(params[:parent_item_id])
      @child_items = @parent_item.children
    when "add_child_items"
      @parent_item = Place.find(params[:parent_item_id])
    when "add_item"
      @parent_item = Place.new
    end
  end

  def create
    @place = Place.new(params[:place])

    if @place.save
      redirect_to places_path, notice: 'Successfully created.'
    else
      redirect_to places_path, alert: 'Wrooongg.'
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])

    if @place.update_attributes(params[:place])
      redirect_to places_path
    else
      redirect_to places_path(parent_place_id: params[:parent_place_id])
    end
  end

  def destroy
    @place = Place.find(params[:id])
    if @place.destroy

    end
  end

  def find_by_name
    @places = Place.fulltext_search(params[:query])
    render json: @places.map(&:hierarchical_name)
  end

  private
  def should_be_admin
    unless current_user.try(:admin?)
      redirect_to root_path
    end
  end
end