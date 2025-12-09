class CartItem < ApplicationRecord
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :session_id, presence: true
  
  def total_price
    quantity * product.price
  end
  
  scope :for_session, ->(session_id) { where(session_id: session_id) }
end
