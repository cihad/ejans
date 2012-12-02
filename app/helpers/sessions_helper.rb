module SessionsHelper
  def current_user
    warden.user
  end

  def user_signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def authenticate_user!
    unless user_signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end