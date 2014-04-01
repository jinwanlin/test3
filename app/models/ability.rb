class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
      can :manage, :all
    else
      cannot :read, [Product, Order, User]
      # cannot [:index, :destroy, :active, :frost, :show], User
    end
  end
end
