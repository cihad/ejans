module Fields
  class ImagesController < ApplicationController
    before_filter :node
    before_filter :images, only: [:destroy, :sort]
    respond_to :js
    include ControllerHelper

    def create
      @images = @node.send("#{params[:keyname]}_add_images", params[:fields_image][:image])
      @keyname = params[:keyname]
    end

    def destroy
      @image = @images.find(params[:id])
      @image.destroy
    end

    def sort
      sort_fields params[:fields_image], @images
      render nothing: true
    end

    private
    def node
      @node = Node.find(params[:node_id])
    end

    def images
      @images = @node.send(params[:keyname])
    end
  end
end