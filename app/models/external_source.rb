# == Schema Information
#
# Table name: external_sources
#
#  id                   :integer(4)      not null, primary key
#  google_alert_feed_id :integer(4)
#  url                  :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  view                 :boolean(1)      default(FALSE)
#  google_url           :string(255)
#

class ExternalSource < ActiveRecord::Base
  attr_accessible :url, :google_url, :view, :google_alert_feed_id
  # Associations
  belongs_to :google_alert_feed
end
