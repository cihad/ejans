class SessionsController < ApplicationController
  skip_before_filter :username_is_nil
  layout "small"
  
  def new
    flash.now.alert = warden.message
  end

  def create
    warden.authenticate!
    redirect_back_or user_path(warden.user)
  end

  def destroy
    warden.logout
    redirect_to root_url
  end
end