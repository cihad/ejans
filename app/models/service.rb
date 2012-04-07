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
  define_index do
    indexes description
    indexes title
    indexes selections.label, as: :selection_label
  end

  mount_uploader :image, ServiceImageUploader

  def selections_map
    h = Hash.new { |hash, key| hash[key] = [] }
    selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
  end

  def selections_map_by_selection_ids(selections_ids)
    h = Hash.new { |hash, key| hash[key] = [] }
    selections = Selection.includes(:filter).find(selection_ids)
    selections.inject(h) { |hash, selection| hash[selection.filter.id] << selection.id; hash }
  end

  def selected_notification_by_selection_ids?(notification, selection_ids = [])
    notification_selections_map = notification.selections_map
    selections_map_by_selection_ids(selection_ids).inject([]) do |a, filter_selection|
      filter_id, selection_ids = filter_selection
      a << (selection_ids & notification_selections_map[filter_id]).present?
      a
    end.all? { |v| v == true }
  end

  def which_notifications(selection_ids = [])
    self.notifications.published.select { |notification| selected_notification_by_selection_ids?(notification, selection_ids) }
  end
end
#
