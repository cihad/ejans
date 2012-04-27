module NotificationsHelper
  def format_desc(desc)
    allowed_tags = %w(p br strong em a table tbody thead tr td h1 h2 h3 h4 h5 h6 ol ul li quote img)
    sanitize desc, tags: allowed_tags
  end

  def conanical(notification = @notification)
    service = notification.services_notifications.first.service
    path = service_notification_path(service ,notification) 
    if notification.services_notifications.count > 1
      conanical_url path
    end
  end
end
