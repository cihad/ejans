class GoogleAlertFeed < ActiveRecord::Base
  # Associations
  belongs_to :service
  has_many :external_sources, dependent: :destroy

  # Validates
  validates :search_key, :feed_url, presence: true
end
