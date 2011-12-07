class Service < ActiveRecord::Base

  FILTER_COUNT = 3
  
  # Associations
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "Account"
  
  has_many :filters, :dependent => :destroy
  accepts_nested_attributes_for :filters,
          :limit => FILTER_COUNT,
          :allow_destroy => true,
          :reject_if => proc { |attributes| attributes['name'].blank? }

  has_one :service_price, :dependent => :destroy
  accepts_nested_attributes_for :service_price, :allow_destroy => true

  has_many :notifications, :dependent => :destroy

  has_many :subscriptions
  has_many :accounts, :through => :subscriptions

  # Validates
  validates_associated :filters
  validates_associated :service_price 

  validates :title, :description, :presence => true
end
