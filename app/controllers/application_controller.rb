class ApplicationController < ActionController::Base
  include LocationHelper
  include Ejans::Authorization

  protect_from_forgery

  layout 'small', if: :devise_controller?

private
  
  def guest
    if params[:email].present?
      guest = Guest.find_or_initialize_by(email: params[:email])
      if guest.save
        current_member = guest
      else
        redirect_to :back, alert: t('guests.invalid_email')
      end
    end
  end
end
