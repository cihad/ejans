# == Schema Information
#
# Table name: credits
#
#  id              :integer(4)      not null, primary key
#  creditable_id   :integer(4)
#  creditable_type :string(255)
#  credit          :integer(4)
#

class Credit < ActiveRecord::Base
  # Associations
  belongs_to :creditable, :polymorphic => true
  has_many :credit_histories

  # Validates
  validates :credit,
    :presence => true, 
    :numericality => { :only_integer => true,
                       :greater_than_or_equal_to => 0 }

end
