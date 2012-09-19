class UserMailer < ActionMailer::Base
  default from: 'info@ejans.com'

  def first_sign_in(user)
    @user = user
    mail(to: user.email, subject: 'Hesap bilgileri - Ejans.com') do |format|
      format.text
      format.html
    end
  end
end