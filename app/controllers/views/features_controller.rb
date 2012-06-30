module Views
  class FeaturesController < ApplicationController
    before_filter :view
    include ControllerHelper

    def destroy
      feature = @view.features.find(params[:id])
      feature.destroy
      redirect_to edit_node_type_views_view_path(@view.node_type, @view), notice: "Yeeappp!"
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