class Notification < ActiveRecord::Base
  # Callbacks
  after_destroy :destroy_selections
  # after_update :send_notification
  after_save :send_notification

  # Associations
  belongs_to :service
  has_and_belongs_to_many :selections
  has_many :notices
  has_many :subscriptions, :through => :notices

  # Scope
  # default_scope where(:published => true)

  # Methods
  def destroy_selections
    self.selections.destroy_all
  end

  def send_notification
    self.add_notification_to_subscriptions #if (self.published_changed? && self.published == true)    
  end

  def add_notification_to_subscriptions
    filters = self.service.filters
    # Nofication's Service's Filters

    notification_selections = {}
    # Nofication's Service's Selections
    # {:filter_id => [selection_id1,selection_id2,...], ...}

    filters.each do |filter|
      notification_selections["#{filter.id}"] = []
      self.selections.each do |selection|
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
        if subscription.account.account_credit.credit.to_i >= self.service.service_price.receiver_credit.to_i
          new_notice = subscription.notices.create!(:notification => self, :read => false)
          subscription.account.account_credit.decrement!(:credit, self.service.service_price.receiver_credit)
        end
      end
    end
  end

end
