class ImagesController < ApplicationController

  before_filter :node_type
  before_filter :node
  before_filter :images, only: [:destroy, :sort]
  respond_to :js

  include ControllerHelper

  def update
    @image = @node.send("#{params[:machine_name]}_add_images", Array(params[:node][params[:machine_name]])).first
    respond_to do |format|
      format.json { render json: [ImagePresenter.new(@image).as_json].to_json }
    end
  end

  def destroy
    @image = @images.find(params[:id])
    @image.destroy
    render nothing: true
  end

  def sort
    sort_fields params[:fields_image], @images
    render nothing: true
  end

  private
  def node_type
    @node_type ||= NodeType.find(params[:node_type_id])
  end

  def node
    @node = Node.find(params[:node_id])
  end

  def images
    @images = @node.send(params[:machine_name])
  end

  def current_resource
    @current_resource ||= node if params[:node_id]
  end
end