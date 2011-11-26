class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :add_initial_breadcrumbs

  layout :template

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
