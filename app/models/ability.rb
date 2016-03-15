class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    can :manage, :all
    cannot :manage, User
    can :read, User

    can :update, User, id: user.id
  end
end
