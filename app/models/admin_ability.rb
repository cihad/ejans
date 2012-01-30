class AdminAbility

  include CanCan::Ability

  
  def initialize(user)
    user ||= Account.new
    
    if user.role? :admin
      can :manage, :all
    end
  end
end