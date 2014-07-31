class StoreController < ApplicationController

  skip_before_action :authenticate_user!

  def home
  	@new_products = Product.order(created_at: :desc).first(8)
    @featured_products = Product.where('featured = ?', true).first(4)
  end

  def about

  end

  def contact

  end
  
end
