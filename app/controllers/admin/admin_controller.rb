class Admin::AdminController < Admin::AdminBaseController
    before_action :authenticate_user!
    layout 'admin'

    def dashboard
        set_setting
        @dashboard = Order.dashboard_data
    end

    def settings
        set_setting
        @settings.build_attachment unless @settings.attachment
    end

    def update
        set_setting
        if @settings.update(params[:store_setting])
            flash_message :success, t('controllers.admin.admin.update.valid')
            redirect_to admin_root_url
        else
            render action: "settings"
        end
    end

    private

    def set_setting
        @settings = Store.settings
    end
end