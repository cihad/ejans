class ExternalSource < ActiveRecord::Base
  attr_accessible :url, :google_alert_feed_id
  # Associations
  belongs_to :google_alert_feed
end
