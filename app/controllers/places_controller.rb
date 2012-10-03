class PlacesController < ApplicationController
  respond_to :js, only: [:index]

  def show
    @place = Place.find(params[:id])
  end

  def index
    @places = Place.roots
    @event = params[:event] if params[:event]
    case @event
    when "show"
      @parent_place = Place.find(params[:parent_place_id])
      @child_places = @parent_place.children
    when "add_child_places"
      @parent_place = Place.find(params[:parent_place_id])
    when "add_place"
      @parent_place = Place.new
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
end