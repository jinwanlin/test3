class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new # guest user (not logged in)
    
    if user.nil?
      cannot :manage, :all
    elsif user.admin?
      can :manage, :all
    else
      # cannot [:index, :destroy, :active, :frost, :show], User
      
      can :read, Company
      cannot [:destroy], Company
      
      can :manage, User
      cannot [:show, :destroy, :recharge], User
      
      can [:read, :search], Product
      cannot [:show, :destroy], Product
      
      can :read, Price
      cannot [:create, :update, :destroy], Price
      
      can :manage, Order
      cannot [:create, :update, :destroy, :print_order, :print_ship], Price
      
      can :manage, OrderItem
      
      can :read, Ship
      
      can :read, Payment
      
      can :read, Pay
      can :read, Recharge
      can :read, Refund
      
    end
  end
end
