class StoreController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
  	@new_products = Product.order('created_at DESC').first(8)
    @featured_products = Product.where('featured = ?', true).first(4)
  end

  def about

  end

  def contact

  end
  
end
