class PlacesController < ApplicationController
  def index
    @places = Place.all
    if params[:parent_place_id]
      if params[:parent_place_id] == "new"
        @parent_place = Place.new
      else  
        @parent_place = Place.find(params[:parent_place_id])
      end
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