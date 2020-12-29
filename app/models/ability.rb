class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin == false
        # https://stackoverflow.com/questions/44497687/a-gem-cancan-access-denied-maincontroller-dashboard?answertab=votes#tab-top
        can :dashboard, :all
        can :access, :rails_admin
        can :read, :dashboard
        can :read, User, id: user.id
        can :update, User, id: user.id
        # can :manage, ModelName, user: user
      elsif user.admin == true
        can :manage, :all
      end
    end
  end
end
