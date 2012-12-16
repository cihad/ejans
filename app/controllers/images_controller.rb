class ImagesController < ApplicationController
  before_filter :node_type
  before_filter :node
  before_filter :images, only: [:destroy, :sort]
  respond_to :js
  include ControllerHelper

  def create
    @images = @node.send("#{params[:machine_name]}_add_images", params[:image][:image])
    @machine_name = params[:machine_name]
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
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def node
    @node = Node.find(params[:node_id])
  end

  def images
    @images = @node.send(params[:machine_name])
  end
end