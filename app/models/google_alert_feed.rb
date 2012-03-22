# == Schema Information
#
# Table name: google_alert_feeds
#
#  id         :integer(4)      not null, primary key
#  service_id :integer(4)
#  feed_url   :string(255)
#  search_key :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class GoogleAlertFeed < ActiveRecord::Base
  # Associations
  belongs_to :service
  has_many :external_sources, dependent: :destroy

  # Validates
  validates :search_key, :feed_url, presence: true
end
