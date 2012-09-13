class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  before_filter :username_is_nil

  private
  def username_is_nil
    if user_signed_in? and current_user.username.blank?
      redirect_to edit_user_path(current_user),
                  alert: "Lutfen kendinize bir username belirleyiniz."
    end
  end
end
