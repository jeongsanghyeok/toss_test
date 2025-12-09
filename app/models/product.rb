class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :category, presence: true

  scope :by_category, ->(category) { where(category: category) }
  
  def average_rating
    return 0 if reviews.empty?
    (reviews.sum(:rating).to_f / reviews.count).round(1)
  end

  # 상세 이미지 URL들을 배열로 처리
  def detail_image_url_array
    return [] if detail_image_urls.blank?
    detail_image_urls.split(',').map(&:strip)
  end

  def detail_image_url_array=(urls)
    self.detail_image_urls = urls.reject(&:blank?).join(',') if urls.is_a?(Array)
  end
end
