class Role < ActiveRecord::Base

  # Associations
  has_and_belongs_to_many :accounts
  
end
# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

