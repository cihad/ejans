class Comment < ActiveRecord::Base

  # Associations
  belongs_to :author, :class_name => "Account", :foreign_key => "author_id"
  belongs_to :notification
  has_many :comments, foreign_key: "parent_id"

  # Validates
  validates :body, presence: true
  validate :not_private_self

  private
  def not_private_self
    if private && author_id && notification.notificationable == author
      error[:base] << "Cannot create self-contact"
      false
    end
  end
end
