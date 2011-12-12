class CreditHistories < ActiveRecord::Base
  belongs_to :credit
  belongs_to :payment_type
  belongs_to :credit_datable
end
