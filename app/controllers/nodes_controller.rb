class NodesController < ApplicationController
  before_filter :node_type
  respond_to :js, only: [:show]
  layout "small", except: [:index, :manage]
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def index
    @nodes = @node_type.filter(params)
  end

  def show
    @node = @node_type.nodes.find(params[:id])
  end

  def new
    unless user_signed_in? and @node = current_user.unpublished_nodes.first
      @node = Node.new(node_type: @node_type, author: current_user)
      @node.save(validate: false)
    end
  end

  def edit
    @node.build_assoc!
  end

  def update
    recaptcha = user_signed_in? ? true : verify_recaptcha(:model => @node, :message => "Oh! It's error with reCAPTCHA!")
    if @node.update_attributes(params[:node]) && recaptcha
      redirect_to [@node_type, @node], notice: 'Node was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @node.destroy
    redirect_to @node_type, notice: "Node was successfully destroyed."
  end

  def manage
    @nodes = @node_type.nodes
  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def correct_user
    @node = @node_type.nodes.find(params[:id])
    unless  (@node.author.blank?)  ||
            (user_signed_in? and current_user == @node.author) ||
            params[:token] == @node.token
      redirect_to root_path,
                  notice: "Bu node'u duzenlemeye yetkili degilsiniz."
    end
  end
end