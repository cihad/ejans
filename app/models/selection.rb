class Selection < ActiveRecord::Base
  # Associations
  belongs_to :filter
  has_and_belongs_to_many :notifications
end
