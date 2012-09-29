class NodeTypesController < ApplicationController
  before_filter :node_type, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index]
  before_filter :must_be_an_administrator, only: [:show, :edit, :update]
  before_filter :admin_user, only: [:index, :new]

  def index
    @node_types = NodeType.
                    includes(:nodes).
                    sort do |nt1, nt2|
                      nt2.nodes.publishing.size <=> nt1.nodes.publishing.size
                    end
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
      @node_type.add_administrator(current_user)
      redirect_to node_type_fields_field_configurations_path(@node_type),
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

  private
  def node_type
    @node_type = NodeType.find(params[:id])
  end

  def must_be_an_administrator
    unless @node_type.administrators.include?(current_user)
      redirect_to node_type_nodes_path(@node_type),
                  alert: "Bunu goruntulemeye yetkilisi degilsiniz."
    end
  end

  def admin_user
    # TODO
    true
  end
end