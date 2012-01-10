class SendNotification
  @queue = :notification_queue

  def self.perform(notification_id)
    notification = Notification.find(notification_id)
    unless notification.subscriptions.blank?
      notification.subscriptions.each do |subscription|
        if subscription.account.credit.credit >= notification.service.service_price.receiver_credit
          new_notice = subscription.notices.create!(:notification => notification)
          subscription.account.credit.decrement!(:credit, notification.service.service_price.receiver_credit)
        end

        if subscription.email?
          Notifier.notification_email(notification, subscription).deliver
        end
      end
    end
  end
  
end