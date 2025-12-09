class Review < ApplicationRecord
  belongs_to :product
  
  validates :user_id, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, presence: true, length: { minimum: 10 }
  
  scope :recent, -> { order(created_at: :desc) }
  
  # 사용자 ID 마스킹 메서드
  def masked_user_id
    return user_id if user_id.length <= 3
    
    visible_chars = user_id.length <= 5 ? 2 : 3
    masked_part = '*' * (user_id.length - visible_chars)
    user_id[0, visible_chars] + masked_part
  end
end
