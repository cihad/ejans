class Credit < ActiveRecord::Base
  # Associations
  belongs_to :creditable, :polymorphic => true
  has_many :credit_histories

end
