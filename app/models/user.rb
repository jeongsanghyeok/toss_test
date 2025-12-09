class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[google_oauth2 kakao naver]

  has_many :orders, dependent: :destroy
  has_many :recently_viewed_products, dependent: :destroy
  has_many :viewed_products, through: :recently_viewed_products, source: :product

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.uid = auth.uid
      
      # 각 프로바이더별로 이름 필드가 다를 수 있음
      case auth.provider
      when 'google_oauth2'
        user.name = auth.info.name if user.respond_to?(:name)
      when 'kakao'
        user.name = auth.info.name || auth.info.nickname if user.respond_to?(:name)
      when 'naver'
        user.name = auth.info.name if user.respond_to?(:name)
      end
    end
  end
end
