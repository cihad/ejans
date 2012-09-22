module Features
  class ImagesController < ApplicationController
    before_filter :node, :feature
    respond_to :js
    include ControllerHelper

    def create
      @images = @feature.add_images(params[:features_image][:image])
    end

    def destroy
      @image = @feature.value.find(params[:id])
      @image.destroy
    end

    def sort
      sort_fields params[:features_image], @feature.value
      render nothing: true
    end

    private
    def node
      @node = Node.find(params[:node_id])
      @node.build_assoc!
    end

    def feature
      @feature = @node.features.find(params[:feature_id])
    end
  end
end