class Service < ActiveRecord::Base
  belongs_to :owner, :foreign_key => "owner_id", :class_name => "Account"
  has_many :filters, :dependent => :destroy
  accepts_nested_attributes_for :filters,
          :allow_destroy => true,
          :reject_if => proc { |attributes| attributes['name'].blank? }
end
