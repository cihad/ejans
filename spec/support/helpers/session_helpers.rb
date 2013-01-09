module SessionHelpers
  def signin_as(role)
    user = Fabricate(role)
    signin user
    user
  end

  def signin(user)
    visit signin_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "123456"
    click_button I18n.t('sessions.signin')
  end
end