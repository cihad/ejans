class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Account.new

    if user.role? :admin
      can :manage, :all
    elsif user.role? :authenticated
      can :read, [Service, Notification]
      can :manage, Subscription
    else
      can :read, [Service, Notification]
    end

  end
end
