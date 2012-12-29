class MailerObserver < Mongoid::Observer
  def after_create(mailer)
    Resque.enqueue(MailerQueue, mailer.id, mailer.node_type.id)
  end
end