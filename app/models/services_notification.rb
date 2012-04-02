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

  # Association
  belongs_to :service
  belongs_to :notification
  has_and_belongs_to_many :selections,
                          join_table: "services_notifications_selections"
end
