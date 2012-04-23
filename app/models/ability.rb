class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Account.new

    if user.role? :admin
      can :manage, :all
    elsif user.role? :authenticated
      can :read, [Service, Notification]
      can :manage, Subscription
      can :create, Notification
      can :update, Notification do |notification|
        user.owner_notification?(notification)
      end
    else
      can :read, [Service, Notification]
    end

  end
end
