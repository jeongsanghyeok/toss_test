class PaymentsController < ApplicationController
  before_action :set_order, only: [:checkout, :confirm]
  
  def checkout
    @cart_items = CartItem.includes(:product).for_session(session.id.to_s)
    
    if @cart_items.empty?
      redirect_to cart_path, alert: '장바구니가 비어있습니다.'
      return
    end

    @total_price = @cart_items.sum(&:total_price)
    @order = Order.new
    # 로그인된 유저가 있으면 기본값 설정
    if user_signed_in?
      @order.user = current_user
      @order.email = current_user.email
    end
  end

  def success
    payment_key = params[:paymentKey]
    order_id = params[:orderId]
    amount = params[:amount].to_i
    
    begin
      # 결제 승인 요청 (토스페이먼츠 API)
      response = HTTParty.post(
        "#{ENV['TOSS_PAYMENTS_BASE_URL']}/v1/payments/confirm",
        headers: {
          'Authorization' => "Basic #{Base64.strict_encode64("#{ENV['TOSS_PAYMENTS_SECRET_KEY']}:")}",
          'Content-Type' => 'application/json'
        },
        body: {
          paymentKey: payment_key,
          orderId: order_id,
          amount: amount
        }.to_json
      )
      
      if response.success?
        # Order 찾기
        order = Order.find_by_order_id(order_id)
        
        if order && order.total_price == amount
          order.update!(
            payment_key: payment_key,
            payment_method: response.parsed_response['method'],
            payment_status: 'completed',
            status: 'completed'
          )
          
          # 장바구니 비우기
          CartItem.for_session(order.session_id).destroy_all
          
          @order = order
          @payment_info = response.parsed_response
        else
          redirect_to payments_fail_path, alert: '결제 정보가 일치하지 않습니다.'
        end
      else
        error_message = response.parsed_response['message'] rescue '결제 승인에 실패했습니다.'
        redirect_to payments_fail_path(message: error_message), alert: error_message
      end
    rescue => e
      Rails.logger.error "결제 승인 오류: #{e.message}"
      redirect_to payments_fail_path, alert: '결제 처리 중 오류가 발생했습니다.'
    end
  end

  def fail
    @error_code = params[:code]
    @error_message = params[:message]
    @order_id = params[:orderId]
  end

  def confirm
    # GET 요청 (새로고침)인 경우 checkout 페이지로 리다이렉트
    if request.get?
      redirect_to payments_checkout_path, notice: '주문서 페이지로 이동합니다.'
      return
    end
    
    # POST 요청 처리
    @cart_items = CartItem.includes(:product).for_session(session.id.to_s)
    
    if @cart_items.empty?
      redirect_to cart_path, alert: '장바구니가 비어있습니다.'
      return
    end

    @order = Order.new(order_params)
    @order.session_id = session.id.to_s
    @order.total_price = @cart_items.sum(&:total_price)
    @order.payment_status = 'pending'
    @order.user = current_user if user_signed_in?

    if @order.save
      render :payment_page
    else
      flash[:alert] = @order.errors.full_messages.join(", ")
      redirect_to payments_checkout_path
    end
  end

  private

  def set_order
    if params[:order_id]
      @order = Order.find(params[:order_id])
    end
  end

  def order_params
    params.require(:order).permit(:name, :email, :phone, :address)
  end
end
