class NodeTypeMailer < ActionMailer::Base
  default from: 'noreply@ejans.com'

  def notify(mailer_template, potential_user)
    @mailer_template = mailer_template
    mail(to: potential_user.email, subject: @mailer_template.subject)
  end
end