class ApplicationController < ActionController::Base
  include SessionsHelper
  include LocationHelper
  include Ejans::Authorization

  protect_from_forgery
  
  before_filter :username_is_nil

  private
  def username_is_nil
    if user_signed_in? and current_user.username.blank?
      redirect_to edit_user_path(current_user),
                  alert: "Lutfen kendinize bir username belirleyiniz."
    end
  end

  def warden
    env['warden']
  end
  helper_method :warden
end
