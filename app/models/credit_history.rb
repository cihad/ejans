# == Schema Information
#
# Table name: credit_histories
#
#  id                  :integer(4)      not null, primary key
#  credit_id           :integer(4)
#  credit_datable_id   :integer(4)
#  credit_datable_type :string(255)
#  credit_quantity     :integer(4)
#  price               :decimal(5, 2)
#  created_at          :datetime
#  updated_at          :datetime
#

class CreditHistory < ActiveRecord::Base
  belongs_to :credit
  belongs_to :credit_datable, :polymorphic => true
end
