module SubscriptionsHelper
  def subscription_menu_item(noticable_object, title = "")
    title = if title.empty?
              truncate(subscription.service.title, :length => 30)
            else
              t('notifications.all')
            end
    item_title = "#{title}
              #{content_count(noticable_object.unread_notices_count)}".html_safe
    path = noticable_object.is_a?(Account) ? subscriptions_path : subscription
    menu_item item_title, path, data_remote: true
  end
end
