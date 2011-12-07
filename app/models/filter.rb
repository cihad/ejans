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
