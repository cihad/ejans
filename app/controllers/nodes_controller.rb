class NodesController < ApplicationController
  before_filter :node_type

  def index
    @nodes = @node_type.filter(params)
  end

  def show
    @node = @node_type.nodes.find(params[:id])
  end

  def new
    @node = @node_type.nodes.build
    @node.build_assoc!
    # render :inline => "<%= @node.features.first.feature_object.value %>"
  end

  def edit
    @node = @node_type.nodes.find(params[:id])
    @node.build_assoc!
  end

  def create
    @node = @node_type.nodes.build(params[:node])

    if @node.save
      redirect_to node_type_node_path(@node_type, @node),
        notice: 'Node was successfully created.'
    else
      render action: "new"
    end
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