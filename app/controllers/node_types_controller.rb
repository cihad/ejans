class NodeTypesController < ApplicationController
  def index
    @node_types = NodeType.all
  end

  def show
    @node_type = NodeType.find(params[:id])
  end

  def new
    @node_type = NodeType.new      
  end

  def edit
    @node_type = NodeType.find(params[:id])
  end

  def create
    @node_type = NodeType.new(params[:node_type])

    if @node_type.save
      redirect_to @node_type, notice: 'Node type was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @node_type = NodeType.find(params[:id])

    if @node_type.update_attributes(params[:node_type])
      redirect_to @node_type, notice: 'Nodetype was successfully updated.'
    else
      render action: "edit"
    end
  end
end