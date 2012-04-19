module NotificationsHelper
  def format_desc(desc)
    allowed_tags = %w(p strong em a table tbody thead tr td h1 h2 h3 h4 h5 h6 ol ul li quote)
    sanitize desc, tags: allowed_tags
  end
end
