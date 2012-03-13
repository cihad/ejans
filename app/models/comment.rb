class Comment < ActiveRecord::Base

  # Associations
  belongs_to :author, class_name: "Account", foreign_key: "author_id"
  belongs_to :notification
  belongs_to :parent, foreign_key: "parent_id", class_name: "Comment"
  has_many :comments, foreign_key: "parent_id"

  # Validates
  validates :body, presence: true
  validate :not_private_self
  validate :not_send_parent_unless_private

  private
  def not_private_self
    if private && author_id && notification.notificationable == author
      error[:base] << "Cannot create self-contact"
    end
  end

  def not_send_parent_unless_private
    if parent_id && !parent.private?
      error[:base] << "Cannot create child comment unless parent private"
    end
  end
end
