module Views
  class FeaturesController < ApplicationController
    before_filter :view

    def destroy
      feature = @view.features.find(params[:id])
      feature.destroy
      redirect_to @view.node_type, notice: "Yeeappp!"
    end

    def sort
      params[:feature].each_with_index do |id, index|
        feature = @view.features.find(id)
        feature.update_attribute(:position, index+1)
      end
      # render nothing: true
      render js: "console.log('#{params[:feature]}')"
    end

    private

    def view
      @view = Views::View.find(params[:view_id])
    end
  end
end