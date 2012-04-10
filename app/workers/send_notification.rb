class SendNotification
  @queue = :notification_queue

  def self.perform(notification_id)
    notification = Notification.find(notification_id)

    notification.potential_accounts_with_subscriptions.each do |account, subscriptions|
      notice = Notice.create(notification: notification)
      subscriptions.each do |subscription|
        notice.subscriptions << subscription
      end
      Notifier.notification_email(notification, subscriptions).deliver
    end
  end
  
end