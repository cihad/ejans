class ServicePrice < ActiveRecord::Base
  # Associations
  belongs_to :service

  # Validates
  validates :sender_credit, :receiver_credit,
    :presence => true, 
    :numericality => { :only_integer => true,
                       :greater_than_or_equal_to => 0 }
                              

end
