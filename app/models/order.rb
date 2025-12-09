class Order < ApplicationRecord
  belongs_to :user, optional: true
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { with: /\A[0-9]{10,11}\z/, message: "숫자만 10~11자리 입력해주세요" }
  validates :address, presence: true
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :order_id, uniqueness: true, allow_blank: true
  
  enum :status, { pending: 'pending', completed: 'completed', cancelled: 'cancelled' }
  enum :payment_status, { 
    payment_pending: 'pending', 
    payment_in_progress: 'in_progress',
    payment_completed: 'completed', 
    payment_failed: 'failed',
    payment_cancelled: 'cancelled'
  }
  
  before_validation :normalize_phone
  before_validation :generate_order_id
  after_initialize :set_defaults
  
  def payment_ready?
    payment_pending? || payment_status.nil?
  end
  
  def payment_success?
    payment_completed?
  end
  
  def generate_unique_order_id
    "order_#{SecureRandom.hex(8)}_#{Time.current.to_i}"
  end
  
  def self.find_by_order_id(order_id)
    find_by(order_id: order_id)
  end
  
  private
  
  def normalize_phone
    if phone.present?
      # 전화번호에서 특수문자 제거하고 숫자만 남기기
      self.phone = phone.gsub(/[^0-9]/, '')
    end
  end
  
  def set_defaults
    self.status ||= 'pending'
    self.payment_status ||= 'pending'
  end
  
  def generate_order_id
    self.order_id ||= generate_unique_order_id
  end
end
