class NotificationsController < ApplicationController
    skip_before_action :authenticate_user!

    def create
      @sku = Sku.includes(:category, :product).find(params[:sku_id])
      @notification = @sku.notifications.build(params[:notification])
      
      respond_to do |format|
        if @notification.save
          format.js { render partial: theme_presenter.page_template_path('products/skus/notify/success'), format: [:js] }
        else
          format.json { render json: { errors: @notification.errors.to_json(root: true) }, status: 422 }
        end
      end
    end

end