class Ability
    include CanCan::Ability

    def initialize(user)
        if user.blank? or user.roles.empty?
            user ||= User.new
            guest_permissions(user)
        else 
            user_permissions(user)
        end

        if user.role? :admin
            admin_permissions(user)
        end
    end

    def guest_permissions(user)
        can :read, Product
        can :manage, User
        can [:show, :create, :destroy], [Cart]
        can [:create, :destroy], [LineItem]
    end

    def user_permissions(user)
        guest_permissions(user)
    end

    def admin_permissions(user)
        user_permissions(user)
        can :manage, :all
    end

end