class Subscription < ActiveRecord::Base
  # Associations
  belongs_to :account
  belongs_to :service

  has_and_belongs_to_many :selections, :join_table => "subscriptions_selections"
end
