Rails.application.routes.draw do
  # Mypage routes
  get "mypage", to: "mypage#index", as: :mypage
  get "mypage/orders", to: "mypage#orders", as: :mypage_orders
  get "mypage/cancellations", to: "mypage#cancellations", as: :mypage_cancellations
  get "mypage/benefits", to: "mypage#benefits", as: :mypage_benefits
  get "mypage/coupons", to: "mypage#coupons", as: :mypage_coupons
  get "mypage/reviews", to: "mypage#reviews", as: :mypage_reviews
  get "mypage/inquiries", to: "mypage#inquiries", as: :mypage_inquiries
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route
  root "products#index"

  # Products routes
  resources :products, only: [:index, :show]

  # Cart routes
  get "cart", to: "cart#show"

  # Cart items routes
  resources :cart_items, only: [:create, :update, :destroy]

  # Orders routes
  resources :orders, only: [:new, :create, :show]

  # Payment routes
  get "payments/checkout"
  post "payments/confirm"
  get "payments/confirm"  # GET 요청 처리 (페이지 새로고침용)
  get "payments/success"
  get "payments/fail"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
