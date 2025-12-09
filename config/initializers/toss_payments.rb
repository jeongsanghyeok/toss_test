Rails.application.configure do
  config.toss_payments = ActiveSupport::OrderedOptions.new
  
  # 공개 문서 테스트용 키 (TossPayments 공식 문서에서 제공하는 테스트 키)
  config.toss_payments.client_key = "test_ck_N5OWRapdA8dbwLJy01BVo1zEqZKL"
  config.toss_payments.secret_key = "test_sk_docs_OaPz8L5KdmQXkzRz3y47BMw6"
  
  # API URL
  config.toss_payments.api_url = "https://api.tosspayments.com/v1"
end