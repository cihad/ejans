class SendNotification
  @queue = :notification_queue

  def self.perform(notification_id)
    notification = Notification.find(notification_id)
    unless notification.subscriptions.blank?
      notification.subscriptions.each do |subscription|
        unless subscription.account.credit.credit < notification.service.service_price.receiver_credit
          new_notice = subscription.notices.create!(:notification => notification)

          if subscription.email?
            Notifier.notification_email(notification, subscription).deliver
          end

          if subscription.sms?
            # SMS SENDING
          end
        end
      end
    end
  end
  
end