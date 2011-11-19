class Selection < ActiveRecord::Base
  # Associations
  belongs_to :filter
  has_and_belongs_to_many :notifications
  has_and_belongs_to_many :subscriptions, :join_table => "subscriptions_selections"
end
