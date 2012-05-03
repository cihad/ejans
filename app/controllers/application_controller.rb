class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :referer_session
  layout :template

  def after_sign_in_path_for(resource)
    session[:referer] || root_path
  end

  def referer_session
    if account_signed_in? or devise_controller?
      session[:referer] = nil if !session[:referer].nil?
    else
      session[:referer] = request.fullpath
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, notice: "Access denied."
  end

  def current_ability
    @current_ability ||= Ability.new(current_account)
  end

  protected
  def template
    if devise_controller? and action_name != "edit"
      "small"
    else
      "application"
    end
  end
end
