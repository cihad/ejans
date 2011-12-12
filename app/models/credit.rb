class Credit < ActiveRecord::Base
  belongs_to :creditable, :polymorphic => true
end
