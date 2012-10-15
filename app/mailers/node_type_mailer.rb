class NodeTypeMailer < ActionMailer::Base
  default from: 'noreply@ejans.com'

  def invitation(marketing_template, potential_user)
    @marketing_template = marketing_template
    mail(to: potential_user.email, subject: @marketing_template.subject)
  end
end