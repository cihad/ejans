class HomeController < ApplicationController
  before_filter :find_place, only: [:index]
  layout "home"

  def index
    if params[:place_id].present?
      @place = Place.find(params[:place_id])
      create_coordinates_cookie(@place.coordinates)
      redirect_to root_path
    end
  end
end
