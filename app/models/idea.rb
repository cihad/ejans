class Idea < ActiveRecord::Base

  # Associations
  belongs_to :account


  # Validates
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence   => true,
                    :format     => { :with => email_regex }
end
# == Schema Information
#
# Table name: ideas
#
#  id            :integer(4)      not null, primary key
#  account_id    :integer(4)
#  search_string :string(255)
#  suggestion    :text
#  email         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

