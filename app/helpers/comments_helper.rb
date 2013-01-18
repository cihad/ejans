module CommentsHelper
  def comment_date(comment)
    time_ago_in_words(comment.created_at)
  end
end
