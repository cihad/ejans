class UserMailer < ActionMailer::Base
  default from: 'info@ejans.com'

  def first_signin(user)
    @user = user
    mail(to: user.email, subject: 'Hesap bilgileri - Ejans.com')
  end

  def notify_new_user_to_admin(user)
    @user = user
    mail(to: "cihad@ejans.com", subject: "Yeni uye - Ejans.com")
  end
end