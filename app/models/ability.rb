# Ability documentation
#
# The ability class defines the user types and permission within your application. E.g. admin, user and guest.
class Ability
    include CanCan::Ability

    def initialize user
        if user.blank? or user.roles.empty?
            user ||= User.new
            guest_permissions
        else 
            user_permissions
        end

        if user.role? :admin
            admin_permissions
        end
    end

    def guest_permissions
        can :read, Product
        can :read, Category
        can :manage, User
        can [:show, :create, :destroy], [Cart]
        can [:create, :destroy], [CartItem]
    end

    def user_permissions
        guest_permissions
    end

    def admin_permissions
        user_permissions
        can :manage, :all
    end
end