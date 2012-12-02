class NodeTypesController < ApplicationController
  before_filter :node_type, only: [:show, :edit, :update, :destroy, :rebuild_node_model]

  # Authorization Filters
  before_filter :authenticate_user!, except: [:index]
  before_filter :must_be_an_administrator, only: [:show, :edit, :update, :rebuild_node_model]
  before_filter :admin_user, only: [:new]

  layout 'small'

  def index
    @node_types = NodeType.search(params[:q])
  end

  def show; end

  def new
    @node_type = NodeType.new 
  end

  def edit; end

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

  def rebuild_node_model
    @node_type.rebuild_node_model
    redirect_to :back, notice: "Dugum modeli tekrar yuklendi."
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
    redirect_to root_path unless current_user.admin?
  end
end