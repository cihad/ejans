class Notifier < ActionMailer::Base

  default from: "notifier@example.com"

  def notification_email(notification, subscription)
    @notification = notification
    @subscription = subscription

    email = subscription.account.email
    title = notification.title
    mail to: email, subject: @notification.title
  end
end 
