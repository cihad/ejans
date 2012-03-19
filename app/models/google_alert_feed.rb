class GoogleAlertFeed < ActiveRecord::Base
  # Associations
  belongs_to :service

  # Validates
  validates :search_key, :feed_url, presence: true
end
