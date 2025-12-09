class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def new
    redirect_to payments_checkout_path
  end

  def create
    @cart_items = CartItem.includes(:product).for_session(session.id.to_s)
    
    if @cart_items.empty?
      redirect_to cart_path, alert: '장바구니가 비어있습니다.'
      return
    end

    @order = Order.new(order_params)
    @order.session_id = session.id.to_s
    @order.total_price = @cart_items.sum(&:total_price)

    if @order.save
      @cart_items.destroy_all
      redirect_to order_path(@order), notice: '주문이 완료되었습니다.'
    else
      @total_price = @cart_items.sum(&:total_price)
      render :new
    end
  end

  def show
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :email, :phone, :address)
  end
end
