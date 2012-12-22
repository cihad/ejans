class UsersController < ApplicationController
  skip_before_filter :username_is_nil, only: [:edit]

  layout 'small', only: [:new, :create]

  skip_before_filter :authorize, only: [:new, :create]

  before_filter :user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def new
    authorize message: t('users.already_registered')
    @user = User.new
  end

  def create
    authorize message: t('users.already_registered')
    @user = User.new(params[:user])

    if !@user.valid? and @user.errors.messages.keys.include?(:already_sign_up)
      UserMailer.first_signin(User.find_by(email: @user.email)).deliver
      redirect_to signin_path, notice: @user.errors.messages[:already_sign_up].first
    elsif @user.save
      warden.set_user(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "Profile updated"
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

private

  def user
    @user = current_user
  end

  def current_resource
    @current_resource ||= user if params[:id]
  end
end