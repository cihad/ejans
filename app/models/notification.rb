# == Schema Information
#
# Table name: notifications
#
#  id                    :integer(4)      not null, primary key
#  title                 :string(255)
#  sms                   :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  published             :boolean(1)      default(FALSE)
#  published_at          :datetime
#  slug                  :string(255)
#  notificationable_id   :integer(4)
#  notificationable_type :string(255)
#

class Notification < ActiveRecord::Base
  require 'resque'

  SMS_LENGTH = 160

  # Associations
  has_many :services_notifications
  accepts_nested_attributes_for :services_notifications
  has_many :services, through: :services_notifications, uniq: true  
  accepts_nested_attributes_for :services
  has_many :selections, through: :services_notifications
  accepts_nested_attributes_for :selections
  has_many :notices
  has_many :subscriptions, :through => :notices
  belongs_to :notificationable, :polymorphic => true
  has_many :comments, :dependent => :destroy

  # Scope
  scope :published, where(published: true)
  scope :unpublished, where(published: false)
  # Validates
  validates :title, :sms, :description, presence: true
  validates :sms, presence: true, length: { maximum: SMS_LENGTH }

  validate :filter_count
  def filter_count
    services_notifications.inject([]) do |a, sn|
      if sn.service.filters.count != 0 && sn.selections.map(&:filter_id).uniq.count != sn.service.filters.count
        errors.add :base, "Please select minumum a item from each filter."
        break
      end
    end
  end

  validate :not_existing_same_service
  def not_existing_same_service
    if services_notifications.map(&:service_id).count != services_notifications.map(&:service_id).uniq.count
      errors.add :base, "Same service"
    end
  end

  # Kaminari
  paginates_per 10

  # FriendlyID
  extend FriendlyId
  friendly_id :title, :use => :slugged
  

  # Methods
  def free?
    service.service_price.receiver_credit == 0
  end

  after_destroy :destroy_selections
  def destroy_selections
    self.selections.destroy_all
  end

  after_update :send_notification
  def send_notification
    self.add_notification_to_subscriptions if self.published_changed? && self.published == true
  end

  def add_notification_to_subscriptions
    Resque.enqueue(SendNotification, self.id)
  end

  # return [SubscriptionObject1, SubscriptionObject2, ...]
  def potential_subscriptions
    services_notifications.inject([]) do |array, sn|
      array << sn.potential_subscriptions
    end.flatten
  end

  # return { AccountObject1 => [SubscriptionObject1, ...], ...}
  def potential_accounts_with_subscriptions
    potential_subscriptions.group_by { |s| s.account }
  end
end
