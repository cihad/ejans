class NodesController < ApplicationController
  respond_to :js, only: [:show]
  before_filter :node_type
  before_filter :must_be_an_author_or_an_administrator,
                only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:manage]
  before_filter :must_be_an_administrator, only: [:manage]
  layout "small", except: [:index, :manage]

  def index
    @nodes = @node_type.filter(params)
  end

  def show
    @node = @node_type.nodes.find(params[:id])
  end

  def new
    if  user_signed_in? and 
        @node = current_user.unpublished_nodes(@node_type).first and
        !@node.try(:valid?)
      @node.destroy
      @node = nil
    end
    @node ||= @node_type.
              node_classify_name.
              safe_constantize.
              new(node_type_id: @node_type.id, author: current_user)
    @node.save(validate: false)
  end

  def edit
  end

  def update
    recaptcha = if user_signed_in? or @node.email_send?
                  true
                else
                  verify_recaptcha(:model => @node, :message => "Oh! It's error with reCAPTCHA!")
                end
    @node.attributes = params[:"node_type_#{@node_type.name.parameterize('_')}"]
    if @node.statement_save && recaptcha
      redirect_to node_type_node_path(@node_type, @node), notice: 'Node was successfully updated.'
    else
      @node.set_unpublishing
      render action: "edit"
    end
  end

  def destroy
    @node.destroy
    redirect_to @node_type, notice: "Node was successfully destroyed."
  end

  def manage
    @nodes = @node_type.nodes.published
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def must_be_an_author_or_an_administrator
    @node = @node_type.nodes.find(params[:id])
    unless  @node.author.blank? ||
            (user_signed_in? and @node.can_manage?(current_user)) ||
            params[:token] == @node.token
      redirect_to root_path,
                  notice: "Bu node'u duzenlemeye yetkili degilsiniz."
    end
  end

  def must_be_an_administrator
    unless @node_type.administrators.include?(current_user)
      redirect_to node_type_nodes_path(@node_type),
                  alert: "Bunu goruntulemeye yetkili degilsiniz."
    end
  end
end