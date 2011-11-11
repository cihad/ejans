class Service < ActiveRecord::Base
  # Associations
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "Account"
  has_many :filters, :dependent => :destroy
  accepts_nested_attributes_for :filters,
          :allow_destroy => true,
          :reject_if => proc { |attributes| attributes['name'].blank? }

  has_one :service_price, :dependent => :destroy
  accepts_nested_attributes_for :service_price, :allow_destroy => true
end
