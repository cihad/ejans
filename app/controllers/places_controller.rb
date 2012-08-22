class PlacesController < ApplicationController
  respond_to :js, only: [:index]

  def index
    @places = Place.top_places
    @event = params[:event] if params[:event]
    # binding.pry
    case @event
    when "show"
      @parent_place = Place.find(params[:parent_place_id])
      @child_places = @parent_place.child_places
    when "add_child_places"
      @parent_place = Place.find(params[:parent_place_id])
    end
  end

  def create
    @place = Place.new(params[:place])

    if @place.save

    else

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
end