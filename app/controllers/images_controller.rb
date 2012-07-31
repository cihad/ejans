class ImagesController < ApplicationController
  before_filter :node, only: [:create, :destroy]
  before_filter :feature, only: [:create, :destroy]
  respond_to :js
  include ControllerHelper

  def create
    @images = @feature.add_images(params[:features_image][:image])
  end

  def destroy
    @image = Features::Image.find(params[:id])
    @feature.delete_image(@image)
  end

  def sort
    sort_fields params[:features_image], Features::Image
  end

  private
  def node
    @node = Node.find(params[:node_id])
  end

  def feature
    @feature = @node.features.find(params[:feature_id])
  end
end