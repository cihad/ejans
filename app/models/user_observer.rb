class UserObserver < Mongoid::Observer
  def after_create(user)
    Resque.enqueue(AdminNotifyToNewUser, user.id)
  end
end