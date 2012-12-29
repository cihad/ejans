class AdminNotifyToNewUser
  @queue = :mailer_queue

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.notify_new_user_to_admin(user).deliver
  end
end