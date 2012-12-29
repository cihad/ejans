class Permission
  attr_reader :user
  attr_accessor :params

  def initialize(user = nil, params = {})
    @user = user || User.new
    @params = params
    
    allow_for_everyone
    send(@user.role)
  end

  def admin
    allow_all
  end

  def allow_for_everyone
    allow :errors, :not_found
  end

  def anonymous
    allow :node_types, :index

    allow :nodes, [:index, :show]
    allow :nodes, [:new, :create] do |node|
      !node.node_type.signin_required?
    end
    allow :nodes, [:edit, :destroy, :update] do |node|
      node.token == params[:token]
    end

    allow :images, [:create, :destroy, :sort] do |node|
      node.token == params[:token]
    end

    allow :comments, :create

    allow :users, :show
  end

  def registered
    allow :node_types, :index
    allow :node_types, [:show, :edit, :update] do |node_type|
      node_type.administrator_ids.include?(user.id) or node_type.super_administrator_id == user.id
    end
    allow :node_types, :destroy do |node_type|
      node_type.super_administrator_id == user.id
    end

    allow :node_types, :manage do |node_type|
      node_type.administrator_ids.include?(user.id) or
      node_type.super_administrator_id == user.id
    end
    
    allow :"custom_fields/fields", [:index, :new, :create, :edit, :update, :destroy, :sort] do |node_type|
      node_type.administrator_ids.include?(user.id) or
      node_type.super_administrator_id == user.id
    end

    allow :"views/nodes", [:edit, :update] do |node_type|
      node_type.administrator_ids.include?(user.id) or
      node_type.super_administrator_id == user.id
    end

    allow :"views/views", [:index, :sort] do |node_type|
      node_type.administrator_ids.include?(user.id) or
      node_type.super_administrator_id == user.id
    end

    allow :"views/views", [:new, :create, :edit, :update, :destroy] do |node_type|
      node_type.super_administrator_id == user.id
    end

    allow :mailers, [:index, :show, :destroy] do |node_type|
      node_type.administrator_ids.include?(user.id) or
      node_type.super_administrator_id == user.id
    end

    allow :mailers, [:new, :create, :edit, :update] do |node_type|
      node_type.super_administrator_id == user.id
    end

    allow :potential_users, [:index, :new, :create, :destroy] do |node_type|
      node_type.administrator_ids.include?(user.id) or
      node_type.super_administrator_id == user.id
    end

    allow :nodes, [:index, :show, :new, :create]
    allow :nodes, [:edit, :update, :destroy] do |node|
      node.author_id == user.id or
      node.node_type.administrator_ids.include?(user.id) or
      node.node_type.super_administrator_id == user.id
    end

    allow :nodes, :change_status do |node|
      node.node_type.administrator_ids.include?(user.id) or
      node.node_type.super_administrator_id == user.id
    end


    allow :images, [:create, :destroy, :sort] do |node|
      node.author_id == user.id
    end

    allow :comments, :create

    allow :comments, :destroy do |comment|
      comment.author_id == user.id
    end

    allow :users, :show
  end

  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end

private

  def allow_all
    @allow_all = true
  end

  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end
end