class PlacesController < ApplicationController

  respond_to :js, only: [:show, :edit, :new, :destroy]

  layout 'small', only: [:index]
  
  def index
    @nodes = Place.roots
  end

  def show
    @node = Place.find(params[:id])
    respond_with @node
  end

  def edit
    @node = Place.find(params[:id])
    respond_with @node
  end

  def new
    @node = Place.new
    respond_with @node
  end

  def create
    @node = Place.new(params[:place])

    if @node.save
      redirect_to places_path, notice: 'Successfully created.'
    else
      redirect_to places_path, alert: 'Wrooongg.'
    end
  end

  def update
    @node = Place.find(params[:id])

    if @node.update_attributes(params[:place])
      redirect_to places_path
    else
      redirect_to places_path
    end
  end

  def destroy
    @node = Place.find(params[:id])
    @node.destroy
    respond_with @node
  end

  def find_by_name
    @places = Place.fulltext_search(params[:query])
    render json: @places.map(&:hierarchical_name)
  end
end