class AddressController < ActionController::Base

    skip_before_filter :authenticate_user!

end