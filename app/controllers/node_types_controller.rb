class NodeTypesController < ApplicationController
  before_filter :node_type, only: [:show, :edit, :update, :destroy, :manage]

  def index
    @node_types = NodeType.search(params[:q])
  end

  def show
  end

  def new
    @node_type = current_user.own_node_types.new
  end

  def edit
  end

  def create
    @node_type = current_user.own_node_types.new(params[:node_type])

    if @node_type.save
      redirect_to node_type_custom_fields_fields_path(@node_type),
                  notice: 'Node type was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @node_type.update_attributes(params[:node_type])
      redirect_to @node_type,
                  notice: 'Nodetype was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    if @node_type.destroy
      redirect_to node_types_path,
                  notice: "#{@node_type.name} basarili bir sekilde kaldirildi."
    end
  end

  def manage
    @nodes = @node_type.nodes
  end

  private

  def node_type
    @node_type = current_resource
  end

  def current_resource
    @current_resource ||= NodeType.find(params[:id]) if params[:id]
  end
end