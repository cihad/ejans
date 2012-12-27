class UsersController < ApplicationController
  before_filter :set_user

  def index
  end

private

  def set_user
    @user = current_user
  end
end
