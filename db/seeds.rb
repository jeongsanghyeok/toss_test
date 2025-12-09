# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data (in order to avoid foreign key constraints)
CartItem.destroy_all
Product.destroy_all

# Create sample products
products_data = [
  {
    name: "iPhone 15 Pro",
    description: "최신 iPhone 15 Pro 모델입니다. A17 Pro 칩과 티타늄 디자인으로 더욱 강력해졌습니다. ProRAW와 ProRes 촬영을 지원하며, 액션 버튼이 새롭게 추가되었습니다.",
    price: 1549000,
    category: "전자기기",
    image_url: "/images/products/iphone-15-pro.jpg"
  },
  {
    name: "MacBook Air M3",
    description: "13인치 MacBook Air M3 칩 탑재. 초경량 디자인과 뛰어난 성능을 자랑합니다. 최대 18시간의 배터리 사용이 가능하며, 매직 키보드와 터치ID를 지원합니다.",
    price: 1590000,
    category: "전자기기",
    image_url: "/images/products/macbook-air-m3.jpg"
  },
  {
    name: "캐시미어 니트",
    description: "100% 캐시미어 소재의 고급 니트입니다. 부드러운 촉감과 우아한 디자인이 특징입니다. 가을과 겨울 시즌에 완벽한 아이템입니다.",
    price: 189000,
    category: "의류",
    image_url: "/images/products/cashmere-knit.jpg"
  },
  {
    name: "프리미엄 데님 재킷",
    description: "최고급 데님 원단으로 제작된 클래식 재킷입니다. 빈티지 워싱 처리로 자연스러운 색감을 연출했습니다. 사계절 착용 가능한 versatile한 아이템입니다.",
    price: 159000,
    category: "의류",
    image_url: "/images/products/denim-jacket.jpg"
  },
  {
    name: "프로그래밍 완전 정복",
    description: "초보자부터 전문가까지 모든 단계의 프로그래머를 위한 완벽한 가이드북입니다. 실무에서 바로 활용할 수 있는 예제와 팁들이 가득합니다.",
    price: 35000,
    category: "도서",
    image_url: "/images/products/programming-book.jpg"
  },
  {
    name: "웹 개발의 모든 것",
    description: "현대 웹 개발에 필요한 모든 기술을 다룬 종합 가이드입니다. HTML, CSS, JavaScript부터 최신 프레임워크까지 체계적으로 학습할 수 있습니다.",
    price: 42000,
    category: "도서",
    image_url: "/images/products/web-development-book.jpg"
  },
  {
    name: "무선 블루투스 이어폰",
    description: "프리미엄 무선 이어폰으로 뛰어난 음질과 노이즈 캔슬링 기능을 제공합니다. 최대 30시간 재생이 가능하며, 방수 기능도 지원합니다.",
    price: 299000,
    category: "전자기기",
    image_url: "/images/products/bluetooth-earphones.jpg"
  },
  {
    name: "스마트 워치",
    description: "건강 관리와 편의성을 모두 갖춘 스마트 워치입니다. 심박수, 수면 패턴, 운동량을 정확히 측정하며, 다양한 앱을 지원합니다.",
    price: 459000,
    category: "전자기기",
    image_url: "/images/products/smart-watch.jpg"
  },
  {
    name: "아로마 디퓨저",
    description: "초음파 방식의 아로마 디퓨저로 은은한 향과 함께 습도 조절 효과까지 제공합니다. LED 조명 기능과 타이머 설정이 가능합니다.",
    price: 89000,
    category: "생활용품",
    image_url: "/images/products/aroma-diffuser.jpg"
  },
  {
    name: "프리미엄 텀블러",
    description: "이중벽 스테인리스 스틸 소재의 고급 텀블러입니다. 12시간 보온, 24시간 보냉 기능으로 언제나 최적의 온도를 유지합니다.",
    price: 45000,
    category: "생활용품",
    image_url: "/images/products/premium-tumbler.jpg"
  },
  {
    name: "실크 스카프",
    description: "100% 실크 소재의 고급스러운 스카프입니다. 우아한 패턴과 부드러운 촉감으로 어떤 스타일링에도 완벽하게 어울립니다.",
    price: 125000,
    category: "의류",
    image_url: "/images/products/silk-scarf.jpg"
  },
  {
    name: "요가 매트",
    description: "친환경 TPE 소재로 제작된 프리미엄 요가 매트입니다. 뛰어난 그립감과 쿠션감으로 안전하고 편안한 운동을 도와줍니다.",
    price: 79000,
    category: "생활용품",
    image_url: "/images/products/yoga-mat.jpg"
  }
]

products_data.each do |product_attrs|
  Product.create!(product_attrs)
end

puts "#{Product.count}개의 상품이 생성되었습니다."
