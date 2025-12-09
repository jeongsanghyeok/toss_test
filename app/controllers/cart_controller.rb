class CartController < ApplicationController
  def show
    @cart_items = CartItem.includes(:product).for_session(session.id.to_s)
    @total_price = @cart_items.sum(&:total_price)
  end
end
