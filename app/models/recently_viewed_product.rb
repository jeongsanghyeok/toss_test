class RecentlyViewedProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :user_id }
  validates :viewed_at, presence: true

  scope :recent, -> { order(viewed_at: :desc) }
  scope :limit_to, ->(count) { limit(count) }

  # 사용자의 최근 본 상품 추가/업데이트
  def self.add_for_user(user, product)
    return unless user && product
    
    viewed = find_or_initialize_by(user: user, product: product)
    viewed.viewed_at = Time.current
    viewed.save!
    
    # 최근 본 상품을 최대 20개로 제한
    cleanup_old_records(user, 20)
    
    viewed
  end

  # 오래된 기록 정리
  def self.cleanup_old_records(user, keep_count = 20)
    old_records = where(user: user)
                    .order(viewed_at: :desc)
                    .offset(keep_count)
    
    old_records.destroy_all if old_records.any?
  end
end
