class ImagesController < ApplicationController
  before_filter :node, only: [:create, :destroy]
  respond_to :js
  include ControllerHelper

  def create
    @images = @node.add_images(params)
  end

  def destroy
    @image = Features::Image.find(params[:id])
    @node.delete_image(@image)
    @image.destroy
  end

  def sort
    sort_fields params[:features_image], Features::Image
  end

  private
  def node
    @node = Node.find(params[:node_id])
  end
end