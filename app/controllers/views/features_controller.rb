module Views
  class FeaturesController < ApplicationController
    before_filter :view
    include ControllerHelper


    def destroy
      feature = @view.features.find(params[:id])
      feature.destroy
      redirect_to @view.node_type, notice: "Yeeappp!"
    end

    def sort
      sort_fields params[:feature], @view.features
    end

    private

    def view
      @view = Views::View.find(params[:view_id])
    end
  end
end