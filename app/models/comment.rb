class Comment < ActiveRecord::Base

  # Associations
  belongs_to :author, :class_name => "Account", :foreign_key => "author_id"
  belongs_to :notification

  # Validates
  validates :body, presence: true
end
