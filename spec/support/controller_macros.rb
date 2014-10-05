module ControllerMacros
    def login_admin
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:admin]
            admin = create(:admin)
            sign_in :user, admin
        end
    end

    def login_user
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            # user = create(:user)
            # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
            sign_in create(:user)
        end
    end
end