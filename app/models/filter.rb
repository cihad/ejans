class Filter < ActiveRecord::Base
  # Associations
  belongs_to :service
  has_many :selections, :dependent => :destroy
  accepts_nested_attributes_for :selections,
          :allow_destroy => true,
          :reject_if => proc { |attributes| attributes['label'].blank? }

  # Validates
  validates_associated :selections
  validates :name, :presence => true
end
# == Schema Information
#
# Table name: filters
#
#  id         :integer(4)      not null, primary key
#  service_id :integer(4)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

