class SettlementsController < ApplicationController

  def index
    @place = Place.roots.first
  end

  def show
    @place = Place.find(params[:id])
  end
end