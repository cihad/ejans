class NodesController < ApplicationController
  respond_to :js, only: [:show]
  before_filter :node_type
  before_filter :node, only: [:show, :edit, :update, :destroy, :change_owner]
  before_filter :must_be_an_author_or_an_administrator,
                only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:manage]
  before_filter :user_signin_required, only: [:new]
  before_filter :must_be_an_administrator, only: [:manage, :change_owner]
  layout "small", except: [:index, :manage]

  def index
    @nodes = NodesQuery.new(@node_type, params).results
  end

  def show
  end

  def new
    @node = NewNode.new(@node_type, current_user).node
  end

  def edit
  end

  def update
    recaptcha = (user_signed_in? or @node.email_send?) || 
                verify_recaptcha(:model => @node, :message => "Oh! It's error with reCAPTCHA!")

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

  def change_owner
    unless params[:show_form].present?
      ChangeNodeOwner.new(@node, params[:change_node_owner][:new_author_email]).save
      redirect_to manage_node_type_nodes_path(@node_type, @node)
    end
  end

  private
  def node_type
    @node_type ||= NodeType.find(params[:node_type_id])
  end

  def node
    @node ||= node_type.nodes.find(params[:id])
  end

  def must_be_an_author_or_an_administrator
    unless  node.author.blank? ||
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

  def user_signin_required
    if @node_type.signin_required? and !user_signed_in?
      redirect_to node_type_nodes_path(@node_type),
        alert: "Bu listeye node ekleyebilmek icin kullanici girisi yapmaniz gerekmektedir."
    end
  end
end