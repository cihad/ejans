# == Schema Information
#
# Table name: payment_type_selections
#
#  id              :integer(4)      not null, primary key
#  payment_type_id :integer(4)
#  credit          :integer(4)
#  price           :integer(10)
#  active          :boolean(1)      default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#

class PaymentTypeSelection < ActiveRecord::Base

  # Assocations
  belongs_to :payment_type

end
