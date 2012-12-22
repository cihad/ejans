class PotentialUsersController < ApplicationController
  before_filter :node_type

  def index
    @potential_users = @node_type.potential_users
  end

  def new
  end

  def create
    added_user, total_email = PotentialUser.create_potential_users(params[:potential_users])
    redirect_to node_type_potential_users_path(@node_type), notice: "#{added_user}/#{total_email} added."
  end

  def destroy

  end

  private
  def node_type
    @node_type = NodeType.find(params[:node_type_id])
  end

  def current_resource
    @current_resource ||= node_type
  end
end