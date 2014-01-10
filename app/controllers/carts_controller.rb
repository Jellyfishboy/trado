class CartsController < ApplicationController

  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy
  end

end
