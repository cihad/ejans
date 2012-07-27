class NodesController < ApplicationController
  before_filter :node_type

  def index
    @nodes = @node_type.filter(params)
    if params[:node_id]
      @node = Node.find(params[:node_id])
      @node.build_assoc!
    end
  end

  def show
    @node = @node_type.nodes.find(params[:id])
    @node.build_assoc!
  end

  def new
    unless @node = @node_type.nodes.unpublished.first
      @node = Node.new(node_type: @node_type)
      @node.save(validate: false)
    end
  end

  def edit
    @node = @node_type.nodes.find(params[:id])
    @node.build_assoc!
  end

  def update
    @node = @node_type.nodes.find(params[:id])
    if @node.update_attributes(params[:node])
      redirect_to [@node_type, @node], notice: 'Node was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @node = @node_type.nodes.find(params[:id])
    @node.destroy
    redirect_to @node_type, notice: "Node was successfully destroyed."
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end
end