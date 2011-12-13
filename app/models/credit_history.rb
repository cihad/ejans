class CreditHistory < ActiveRecord::Base
  belongs_to :credit
  belongs_to :credit_datable, :polymorphic => true
end
