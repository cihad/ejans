module SubscriptionsHelper
  def subscription_menu_item(noticable_object, title = "")
    title = if noticable_object.is_a?(Account)
              t('notifications.all')
            else
              truncate(noticable_object.service.title, :length => 30)
            end
    item_title = "#{title}
              #{count_tag(noticable_object.unread_notices_count)}".html_safe
    path = noticable_object.is_a?(Account) ? subscriptions_path : noticable_object
    menu_item item_title, path, data_remote: true
  end
end
