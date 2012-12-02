module SessionHelpers
  def signin_as(role)
    @user = Fabricate(role)
    signin_with @user.email
  end

  def signin(user)
    signin_with(user.email)
  end

  def signin_with(email_or_username, password = "123456")
    visit signin_path
    fill_in I18n.t('sessions.email_or_username'), with: email_or_username
    fill_in I18n.t('sessions.password'), with: password
    click_button I18n.t('sessions.signin')
  end

  def signout(user)
    click_link user.username_or_email_name
    click_link I18n.t('sessions.signout')
  end
end