class FiltersController < ApplicationController
  
  def create
    @filter = Filter.new(params[:filter])
    if @filter.save
      redirect_to selections_service_path(@filter.service)
    end
  end

  def destroy
    filter = Filter.find(params[:id])
    if filter.destroy
      redirect_to selections_service_path(filter.service)
    end
  end
end