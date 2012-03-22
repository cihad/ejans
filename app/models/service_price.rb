# == Schema Information
#
# Table name: service_prices
#
#  id              :integer(4)      not null, primary key
#  service_id      :integer(4)
#  sender_credit   :integer(4)      default(0)
#  receiver_credit :integer(4)      default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

class ServicePrice < ActiveRecord::Base
  # Associations
  belongs_to :service

  # Validates
  validates :sender_credit, :receiver_credit,
    :presence => true, 
    :numericality => { :only_integer => true,
                       :greater_than_or_equal_to => 0 }
                              

end
