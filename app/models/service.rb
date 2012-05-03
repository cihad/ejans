# == Schema Information
#
# Table name: services
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  image       :string(255)
#

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

  has_many :services_notifications, dependent: :destroy
  has_many :notifications, through: :services_notifications

  has_many :subscriptions
  has_many :accounts, :through => :subscriptions

  has_many :google_alert_feeds, dependent: :destroy
  accepts_nested_attributes_for :google_alert_feeds,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes['feed_url'].blank? or
      attributes['search_key'].blank? }

  # Validates
  validates_associated :filters
  validates_associated :service_price 

  validates :title, :description, :presence => true

  # FriendlyID
  extend FriendlyId
  friendly_id :title, :use => :slugged

  # Sphinx Search Engine
  if respond_to? :define_index
    define_index do
      indexes title
      indexes description
      indexes selections.label, as: :selection_label
    end
  end

  mount_uploader :image, ServiceImageUploader
end
#
