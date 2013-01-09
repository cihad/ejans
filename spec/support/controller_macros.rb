module ControllerMacros
  def signin(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end