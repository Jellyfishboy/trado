class StoreController < ApplicationController

  skip_before_action :authenticate_user!

  def home
  	@new_products = Product.active.published.order(created_at: :desc).first(8)
    @featured_products = Product.active.published.where(featured: true).first(4)
  end

  def about

  end  
end
