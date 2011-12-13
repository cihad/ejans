class PaymentType < ActiveRecord::Base
    
  # Associations
  has_many :credit_histories, :as => :credit_datable
  has_many :payment_type_selections
  accepts_nested_attributes_for :payment_type_selections,
          :allow_destroy => true,
          :reject_if => proc { |attributes| attributes['credit'].blank? or attributes['price'].blank? }
end
