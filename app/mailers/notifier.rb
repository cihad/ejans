class Notifier < ActionMailer::Base

  default from: "notifier@ejans.com"

  def notification_email(notification, subscriptions)
    @notification = notification
    @subscriptions = subscriptions

    email = subscriptions.first.account.email
    title = notification.title
    mail to: email, subject: @notification.title
  end
end
