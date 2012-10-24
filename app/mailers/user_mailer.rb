class UserMailer < ActionMailer::Base
  default from: 'info@ejans.com'

  def first_sign_in(user)
    @user = user
    mail(to: user.email, subject: 'Hesap bilgileri - Ejans.com') do |format|
      format.text
      format.html
    end
  end

  def notify_new_user_to_admin(user)
    @user = user
    mail(to: "cihad@ejans.com", subject: "Yeni uye - Ejans.com")
  end
end