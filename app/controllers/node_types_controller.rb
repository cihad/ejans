class NodeTypesController < ApplicationController
  before_filter :node_type, only: [:show, :edit, :update]
  before_filter :authenticate_user!, except: [:index]
  before_filter :administrator, only: [:show, :edit, :update]

  def index
    @node_types = NodeType.all
  end

  def show
  end

  def new
    @node_type = NodeType.new      
  end

  def edit
  end

  def create
    @node_type = NodeType.new(params[:node_type])

    if @node_type.save
      @node_type.administrator << current_user
      redirect_to @node_type, notice: 'Node type was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @node_type.update_attributes(params[:node_type])
      redirect_to @node_type, notice: 'Nodetype was successfully updated.'
    else
      render action: "edit"
    end
  end

  private
  def node_type
    @node_type = NodeType.find(params[:id])
  end

  def administrator
    unless @node_type.administrators.include?(current_user)
      redirect_to node_type_nodes_path(@node_type),
                  alert: "Bunu goruntulemeye yetkilisi degilsiniz."
    end
  end
end