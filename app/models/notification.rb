class Notification < ActiveRecord::Base

  SMS_LENGTH = 160

  # Callbacks
  after_destroy :destroy_selections
  after_update :send_notification

  # Associations
  belongs_to :service
  has_and_belongs_to_many :selections
  has_many :notices
  has_many :subscriptions, :through => :notices
  belongs_to :notificationable, :polymorphic => true

  # Scope
  scope :published, where(:published => true)
  scope :unpublished, where(:published => false)
  scope :available, where("available_until > ?", Date.today - 1)
  scope :unavailable, where("available_until < ?", Date.today)

  # Validates
  validates :title, :sms, :description, :available_until,
    :presence => true
  validates :sms,
    :presence => true,
    :length => { :maximum => SMS_LENGTH }

  # validate :available_until_date_cannot_be_in_the_past

  def available_until_date_cannot_be_in_the_past
    if available_until < Date.today
      errors.add(:available_until, "can't be in the past")
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
    unless subscriptions.blank?
      self.subscriptions.each do |subscription|
        if subscription.account.credit.credit >= service.service_price.receiver_credit
          new_notice = subscription.notices.create!(:notification => self)
          subscription.account.credit.decrement!(:credit, self.service.service_price.receiver_credit)
        end
      end
    end
  end

  def subscription_count(selections = [])
    which_subscriptions_by_selection_ids(selections).count
  end

  def subscription_price(selections = [])
    subscription_count = subscription_count(selections)
    return self.service.service_price.sender_credit * subscription_count
  end

  def valid_filter?(selection_ids)
    if selection_ids.nil?
      false
    else
      array = selection_ids.inject([]) do |a, id|
                a << Selection.find(id).filter_id
                a
              end

      array.uniq.size == self.service.filters.size ? true : false
    end
  end

end
