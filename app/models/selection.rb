# == Schema Information
#
# Table name: selections
#
#  id         :integer(4)      not null, primary key
#  filter_id  :integer(4)
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer(4)
#

class Selection < ActiveRecord::Base

  attr_accessor :multiple_selections

  # Associations
  belongs_to :service
  belongs_to :filter
  has_and_belongs_to_many :notifications
  has_and_belongs_to_many :subscriptions, :join_table => "subscriptions_selections"

  # Validations
  validates :label, presence: true
end
