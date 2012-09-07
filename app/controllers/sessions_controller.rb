class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:session][:email_or_username], params[:session][:password])
    if user
      sign_in user
      redirect_back_or user
    else
      flash.now[:alert] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end