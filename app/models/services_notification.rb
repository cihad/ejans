# == Schema Information
#
# Table name: services_notifications
#
#  id              :integer(4)      not null, primary key
#  notification_id :integer(4)
#  service_id      :integer(4)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class ServicesNotification < ActiveRecord::Base
  include Ejans::Selectable

  # Association
  belongs_to :service
  accepts_nested_attributes_for :service
  belongs_to :notification
  has_and_belongs_to_many :selections,
                          join_table: "services_notifications_selections"
  accepts_nested_attributes_for :selections

  # Validates
  validates :service_id, presence: true
end
