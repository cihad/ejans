class UsersController < ApplicationController
  before_filter :authenticate_user!, 
                only: [:edit, :update, :destroy]
  before_filter :correct_user, only: [:show, :edit, :update]
  skip_before_filter :username_is_nil, only: [:edit]
  before_filter :must_be_admin, only: [:index]

  layout 'small', only: [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if !@user.valid? and @user.errors.messages.keys.include?(:already_sign_up)
      UserMailer.first_sign_in(User.find_by(email: @user.email)).deliver
      redirect_to signin_path, notice: @user.errors.messages[:already_sign_up].first
    elsif @user.save
      warden.set_user(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def must_be_admin
    unless current_user.try :admin?
      redirect_to root_path
    end
  end
end