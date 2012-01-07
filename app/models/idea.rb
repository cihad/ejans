class Idea < ActiveRecord::Base

  # Associations
  belongs_to :account


  # Validates
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence   => true,
                    :format     => { :with => email_regex }
end
