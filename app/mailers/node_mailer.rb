class NodeMailer < ActionMailer::Base

  default from: 'nodemailer@ejans.com'

  def node_info_mailer(node)
    @node = node
    mail(to: @node.author.email, subject: 'Yeni node eklediniz - Ejans.com')
  end

end