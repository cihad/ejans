class AdminAbility

  include CanCan::Ability

  user ||= Account.new
  
  def initialize(user)
    if user.role? :admin
      can :manage, :all
    end
  end
end