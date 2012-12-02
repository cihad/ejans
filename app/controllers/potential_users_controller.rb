class PotentialUsersController < ApplicationController
  before_filter :node_type
  before_filter :authenticate_user!
  before_filter :must_be_an_administrator

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

  def must_be_an_administrator
    unless @node_type.administrators.include?(current_user)
      redirect_to node_type_nodes_path(@node_type),
                  alert: "Bunu goruntulemeye yetkilisi degilsiniz."
    end
  end
end