class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Account.new

    if user.role? :admin
      can :manage, :all
    elsif user.role? :authenticated
      can :read, [Service, Subscription]
      can :update, [Subscription]
      can :create
    else
      can :read, [Service, Notification]
    end


  end
end
