# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer(4)      not null, primary key
#  account_id :integer(4)
#  service_id :integer(4)
#  email      :boolean(1)      default(TRUE)
#  sms        :boolean(1)      default(FALSE)
#  active     :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base
  include Ejans::Selectable
  include Ejans::Noticable

  # Associations
  belongs_to :account
  belongs_to :service

  has_and_belongs_to_many :selections, join_table: "subscriptions_selections"
  has_many :filters, through: :selections, uniq: true

  has_and_belongs_to_many :notices, join_table: "notices_subscriptions"
  has_many :notifications, through: :notices

  # Callbacks
  after_commit :not_new!

  # Validates
  validate :filter_count
  def filter_count
    if service.filters.present? && selections.map(&:filter_id).uniq.count != service.filters.count
      errors.add :base, "Please select minumum a item from each filter."
    end
  end

  def matching_notifications
    service.notifications.select { |notification| self.matching?(notification) }
  end

  def notice(notification)
    self.notices.find_by_notification_id(notification.id)
  end

  def have_notice?(notification)
    self.notice(notification).present?
  end

  def access_notification?(notification)
    self.have_notice?(notification) ? self.notice(notification).sufficient_credit? : false
  end
  
  private
  def not_new!
    self.notices.update_all(new: false)
  end
end
