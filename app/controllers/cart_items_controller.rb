class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:update, :destroy]

  def create
    @product = Product.find(params[:product_id])
    @cart_item = CartItem.find_by(product: @product, session_id: session.id.to_s)

    if @cart_item
      @cart_item.quantity += params[:quantity].to_i
    else
      @cart_item = CartItem.new(
        product: @product,
        quantity: params[:quantity].to_i,
        session_id: session.id.to_s
      )
    end

    if @cart_item.save
      # 장바구니 총 수량 계산
      total_quantity = CartItem.for_session(session.id.to_s).sum(:quantity)
      
      respond_to do |format|
        format.html { redirect_to cart_path, notice: '장바구니에 상품이 추가되었습니다.' }
        format.json { render json: { success: true, message: '장바구니에 상품이 추가되었습니다.', cart_count: total_quantity } }
      end
    else
      respond_to do |format|
        format.html { redirect_to product_path(@product), alert: '장바구니 추가에 실패했습니다.' }
        format.json { render json: { success: false, message: '장바구니 추가에 실패했습니다.' } }
      end
    end
  end

  def update
    if @cart_item.update(quantity: params[:quantity].to_i)
      redirect_to cart_path, notice: '수량이 업데이트되었습니다.'
    else
      redirect_to cart_path, alert: '수량 업데이트에 실패했습니다.'
    end
  end

  def destroy
    @cart_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path, notice: '상품이 장바구니에서 제거되었습니다.' }
      format.json { render json: { success: true, message: '상품이 장바구니에서 제거되었습니다.' } }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to cart_path, alert: '상품을 찾을 수 없습니다.' }
      format.json { render json: { success: false, message: '상품을 찾을 수 없습니다.' } }
    end
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to cart_path, alert: '상품을 찾을 수 없습니다.' }
      format.json { render json: { success: false, message: '상품을 찾을 수 없습니다.' }, status: :not_found }
    end
  end
end
