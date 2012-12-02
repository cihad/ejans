module CommentsHelper
  def comment_date(comment)
    l comment.created_at, format: :short
  end

  def show_comment?(comment, account)
    !comment.private? ||
    (comment.private? && 
      (account == comment.author || 
        account == comment.notification.notificationable))
  end
end
