class Products::NotifyMeController < ApplicationController
    skip_before_action :authenticate_user!

    def new
        set_sku
        render json: { modal: render_to_string(partial: theme_presenter.page_template_path('products/notify-me/modal'), locals: { sku: @sku, notification: @sku.notifications.build }) }, status: 200
    end

    def create
        set_sku
        new_notification
        if @notification.save
            render json: { notification: @notification }, status: 201
        else
            render json: { errors: @notification.errors.full_messages }, status: 422
        end
    end

    private

    def set_sku
        @sku ||= Sku.includes(:product).find(params[:sku_id])
    end

    def new_notification
        @notification ||= @sku.notifications.build(notification_params)
    end

    def notification_params
        params.require(:notification).permit(:email, :notifiable_id, :notifiable_type)
    end
end