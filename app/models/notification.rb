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
#  available_until       :date
#

class Notification < ActiveRecord::Base

  require 'resque'

  SMS_LENGTH = 160

  # Callbacks
  after_destroy :destroy_selections
  after_update :send_notification

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
  scope :available, where("available_until > ?", Date.today - 1)
  scope :unavailable, where("available_until < ?", Date.today)

  # Validates
  validates :title, :sms, :description, :available_until,
    presence: true
  validates :sms, presence: true, length: { maximum: SMS_LENGTH }

  # validate :available_until_date_cannot_be_in_the_past
  # def available_until_date_cannot_be_in_the_past
  #   if available_until < Date.today
  #     errors.add(:available_until, "can't be in the past")
  #   end
  # end

  validate :filter_count
  def filter_count
    services_notifications.inject([]) do |a, sn|
      if sn.service.filters.count != 0 && sn.selections.map(&:filter_id).uniq.count != sn.service.filters.count
        errors.add :base, "Please select minumum a item from each filter."
        break
      end
    end
  end

  validate :same_service
  def same_service
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
  def active?
    self.available_until > Date.today - 1 ? true : false
  end

  def passive?
    !self.active?
  end

  def free?
    self.passive? || (service.service_price.receiver_credit == 0)
  end

  def destroy_selections
    self.selections.destroy_all
  end

  def send_notification
    self.add_notification_to_subscriptions if self.published_changed? && self.published == true
  end

  def selections_map
    h = Hash.new { |hash, key| hash[key] = [] }
    self.selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
  end

  def selections_map_by_selection_ids(selections)
    h = Hash.new { |hash, key| hash[key] = [] }
    selections = Selection.find(selections).includes(:filter)
    selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
  end

  def selected_subscription?(subscription)
    subscription_selections_map = subscription.selections_map
    selections_map.inject([]) do |a, filter_selection|
      filter_id, selection_ids = filter_selection
      a << (selection_ids & subscription_selections_map[filter_id]).present?
      a
    end.all? { |v| v == true }
  end

  def selected_subscription_by_selection_ids?(subscription, selection_ids = [])
    subscription_selections_map = subscription.selections_map
    selections_map_by_selection_ids(selections).inject([]) do |a, filter_selection|
      filter_id, selection_ids = filter_selection
      a << (selection_ids & subscription_selections_map[filter_id]).present?
      a
    end.all? { |v| v == true }
  end

  def subscriptions
    self.service.subscriptions.select { |subscription| selected_subscription?(subscription) }
  end

  def which_subscriptions_by_selection_ids(selections = [])
    self.service.subscriptions.select { |subscription| selected_subscription_by_selection_ids?(subscription, selections) }
  end

  # Native method
  def add_notification_to_subscriptions
    Resque.enqueue(SendNotification, self.id)
  end

  def subscription_count(selections = [])
    which_subscriptions_by_selection_ids(selections).count
  end

  def subscription_price(selections = [])
    subscription_count = subscription_count(selections)
    return self.service.service_price.sender_credit * subscription_count
  end
end
