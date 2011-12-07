class AccountCredit < ActiveRecord::Base
  # Associations
  belongs_to :account

  # Validates
  validates :credit,
    :presence => true, 
    :numericality => { :only_integer => true,
                       :greater_than_or_equal_to => 0 }
end
