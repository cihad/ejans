class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :add_initial_breadcrumbs
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

  protected

    def template
      if devise_controller? and action_name != "edit"
        "small"
      else
        "application"
      end
    end

  private
    
    def add_initial_breadcrumbs
      breadcrumbs.add 'Home', root_path, :id => 'home'
    end

end
