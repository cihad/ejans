class Service < ActiveRecord::Base

  FILTER_COUNT = 3
  
  # Associations
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "Account"
  
  has_many :filters, :dependent => :destroy
  accepts_nested_attributes_for :filters,
          :limit => FILTER_COUNT,
          :allow_destroy => true,
          :reject_if => proc { |attributes| attributes['name'].blank? }

  has_many :selections, :through => :filters

  has_one :service_price, :dependent => :destroy
  accepts_nested_attributes_for :service_price, :allow_destroy => true

  has_many :notifications, :dependent => :destroy

  has_many :subscriptions
  has_many :accounts, :through => :subscriptions

  # Validates
  validates_associated :filters
  validates_associated :service_price 

  validates :title, :description, :presence => true

  # FriendlyID
  extend FriendlyId
  friendly_id :title, :use => :slugged

  def which_notifications(selections = [])
    notifications = []
    filters = self.filters
    # Nofication's Service's Filters

    filters_map = {}
    # Nofication's Service's Selections
    # {:filter_id => [selection_id1,selection_id2,...], ...}

    filters.each do |filter|
      filters_map["#{filter.id}"] = []
      selections.each do |selection|
        selection = Selection.find(selection)
        if selection.filter == filter
          filters_map["#{filter.id}"] << selection.id
        end
      end
    end

    self.notifications.each do |notification|
      notification_selections = {}
      filters.each do |filter|
        notification_selections["#{filter.id}"] = []
        notification.selections.each do |selection|
          if selection.filter == filter
            notification_selections["#{filter.id}"] << selection.id
          end
        end
      end

      array = []
      # [true,false,...]
      notification_selections.each do |filter_id, selection_ids|
        array1 = []
        selection_ids.each do |selection_id|
          if filters_map["#{filter_id}"].include?(selection_id)
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
        notifications << notification
      end
    end

    return notifications.map(&:id)
  end
end
