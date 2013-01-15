class NodesController < ApplicationController
  respond_to :js, only: [:show]

  before_filter :node_type
  before_filter :node, except: :index

  def index
    @nodes = NodesQuery.new(@node_type, params).results
  end

  def show
  end

  def new
    @current_resource = NewNode.new(@node_type, current_user).node
    @node = @current_resource
  end

  def edit
  end

  def update
    recaptcha = (user_signed_in? or @node.email_send?) || 
                verify_recaptcha( :model => @node,
                                  :message => "Oh! It's error with reCAPTCHA!")

    
    if recaptcha && @node.update_attributes(params[:node]) && @node.submit!
      redirect_to node_type_node_path(@node_type, @node),
        notice: 'Node was successfully updated.'
    else
      render action: "new"
    end
  end

  def destroy
    @node.destroy
    redirect_to @node_type, notice: "Node was successfully destroyed."
  end

  def change_status    
    if (event = params[:event]) and @node.send("#{event}!")
      redirect_to :back, notice: t( 'nodes.status_changed',
                                    status: t("nodes.#{event}") )
    else
      redirect_to :back, alert: t(  'nodes.status_not_changed',
                                    expected_status: t("nodes.#{event}"),
                                    current_status: t("nodes.#{@node.status}")  )
    end
  end

  def change_owner
    unless params[:show_form].present?
      ChangeNodeOwner.new(@node, params[:change_node_owner][:new_author_email]).save
      redirect_to manage_node_types_path(@node_type, @node)
    end
  end

  protected

  def node_type
    @node_type ||= NodeType.find(params[:node_type_id])
  end

  def node
    @node = current_resource
  end

  def current_resource
    @current_resource ||= node_type.nodes.find(params[:id]) if params[:id]
  end
end