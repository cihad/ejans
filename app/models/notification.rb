class Notification < ActiveRecord::Base

  SMS_LENGTH = 160

  # Callbacks
  after_destroy :destroy_selections
  after_update :send_notification
  # after_save :send_notification

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

  #validate :available_until_date_cannot_be_in_the_past

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
  

  def destroy_selections
    self.selections.destroy_all
  end

  def send_notification
    self.add_notification_to_subscriptions if self.published_changed? && self.published == true
  end

  def which_subscriptions(selections = [])
    subscriptions = []
    filters = self.service.filters
    # Nofication's Service's Filters

    notification_selections = {}
    # Nofication's Service's Selections
    # {:filter_id => [selection_id1,selection_id2,...], ...}

    filters.each do |filter|
      notification_selections["#{filter.id}"] = []
      selections.each do |selection|
        selection = Selection.find(selection)
        if selection.filter == filter
          notification_selections["#{filter.id}"] << selection.id
        end
      end
    end

    self.service.subscriptions.each do |subscription|
      subscription_selections = {}
      filters.each do |filter|
        subscription_selections["#{filter.id}"] = []
        subscription.selections.each do |selection|
          if selection.filter == filter
            subscription_selections["#{filter.id}"] << selection.id
          end
        end
      end

      array = []
      # [true,false,...]
      subscription_selections.each do |filter_id, selection_ids|
        array1 = []
        selection_ids.each do |selection_id|
          if notification_selections["#{filter_id}"].include?(selection_id)
            array1 << true
          end
        end

        if array1.include? true
          array << true
        else
          array << false
        end
      end

      if !(array.include? false)
        subscriptions << subscription
      end
    end

    return subscriptions
  end

  def add_notification_to_subscriptions
    unless which_subscriptions(self.selections).blank?
      which_subscriptions(self.selections).each do |subscription|
        if subscription.account.credit.credit.to_i >= self.service.service_price.receiver_credit.to_i
          new_notice = subscription.notices.create!(:notification => self, :read => false)
          subscription.account.credit.decrement!(:credit, self.service.service_price.receiver_credit)
        end
      end
    end
  end

  def subcription_count(selections = [])
    which_subscriptions(selections).count
  end

  def subcription_price(selections = [])
    subcription_count = subcription_count(selections)
    return self.service.service_price.sender_credit * subcription_count
  end

  def valid_filter?(selection_ids)
    if selection_ids.nil?
      false
    else
      array = []
      selection_ids.each do |id|
        array << Selection.find(id).filter_id
      end

      if array.uniq.size == self.service.filters.size
        true
      else
        false
      end
    end
  end

end
