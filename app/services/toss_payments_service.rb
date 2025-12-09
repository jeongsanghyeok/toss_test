class TossPaymentsService
  include HTTParty
  
  base_uri Rails.application.config.toss_payments.api_url
  
  def initialize
    @secret_key = Rails.application.config.toss_payments.secret_key
    @client_key = Rails.application.config.toss_payments.client_key
  end
  
  # 결제 승인 요청
  def confirm_payment(payment_key, order_id, amount)
    options = {
      body: {
        paymentKey: payment_key,
        orderId: order_id,
        amount: amount
      }.to_json,
      headers: {
        'Authorization' => "Basic #{Base64.strict_encode64("#{@secret_key}:")}",
        'Content-Type' => 'application/json'
      }
    }
    
    self.class.post('/payments/confirm', options)
  end
  
  # 결제 조회
  def get_payment(payment_key)
    options = {
      headers: {
        'Authorization' => "Basic #{Base64.strict_encode64("#{@secret_key}:")}"
      }
    }
    
    self.class.get("/payments/#{payment_key}", options)
  end
  
  # 결제 취소
  def cancel_payment(payment_key, cancel_reason = "고객 요청")
    options = {
      body: {
        cancelReason: cancel_reason
      }.to_json,
      headers: {
        'Authorization' => "Basic #{Base64.strict_encode64("#{@secret_key}:")}",
        'Content-Type' => 'application/json'
      }
    }
    
    self.class.post("/payments/#{payment_key}/cancel", options)
  end
  
  def client_key
    @client_key
  end
end