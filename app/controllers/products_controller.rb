class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    if params[:category].present?
      # 다단계 카테고리 필터링 로직
      @products = filter_products_by_category
      @show_category_view = true
      @current_category = params[:category]
      @current_subcategory = params[:subcategory]
      @current_detail = params[:detail]
    else
      # 홈페이지용 - 카테고리별로 그룹화
      @all_products = Product.all.limit(8) # 전체 상품 최신 8개
      @categories = ['전자기기', '의류', '도서', '생활용품']
      @products_by_category = {}
      
      @categories.each do |category|
        @products_by_category[category] = Product.by_category(category).limit(4)
      end
      
      # 최근 리뷰 데이터
      @recent_reviews = Review.includes(:product).recent.limit(6)
      
      # 로그인한 사용자의 최근 본 상품
      if user_signed_in?
        @recently_viewed_products = current_user.recently_viewed_products
                                                .includes(:product)
                                                .recent
                                                .limit(6)
                                                .map(&:product)
      end
      
      @show_category_view = false
    end
  end

  def show
    # 로그인한 사용자의 경우 최근 본 상품에 추가
    if user_signed_in?
      RecentlyViewedProduct.add_for_user(current_user, @product)
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def filter_products_by_category
    products = Product.all
    
    # 메인 카테고리로 필터링
    products = products.by_category(params[:category]) if params[:category].present?
    
    # 서브카테고리로 추가 필터링 (예: 휴대폰, 남성, 소설 등)
    if params[:subcategory].present?
      case params[:category]
      when '전자기기'
        products = filter_electronics_subcategory(products, params[:subcategory])
      when '의류'
        products = filter_clothing_subcategory(products, params[:subcategory])
      when '도서'
        products = filter_book_subcategory(products, params[:subcategory])
      when '생활용품'
        products = filter_lifestyle_subcategory(products, params[:subcategory])
      end
    end
    
    # 세부 항목으로 추가 필터링 (예: iPhone, 티셔츠, 추리소설 등)
    if params[:detail].present?
      products = products.where("name LIKE ? OR description LIKE ?", 
                               "%#{params[:detail]}%", "%#{params[:detail]}%")
    end
    
    products
  end

  def filter_electronics_subcategory(products, subcategory)
    case subcategory
    when '휴대폰'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%휴대폰%', '%iPhone%', '%Galaxy%', '%스마트폰%', '%phone%', '%핸드폰%')
    when 'PC/태블릿'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%PC%', '%태블릿%', '%MacBook%', '%iPad%', '%컴퓨터%', '%노트북%', '%데스크톱%', '%laptop%')
    when '게임/콘솔'
      products.where("name LIKE ? OR description LIKE ?", '%게임%', '%콘솔%')
    when '가전제품'
      products.where("name LIKE ? OR description LIKE ?", '%가전%', '%전자%')
    when '웨어러블'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%워치%', '%밴드%', '%웨어러블%', '%스마트워치%', '%watch%', '%band%')
    when '오디오'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%이어폰%', '%헤드폰%', '%스피커%', '%오디오%', '%블루투스%', '%earphone%', '%speaker%')
    else
      products
    end
  end

  def filter_clothing_subcategory(products, subcategory)
    case subcategory
    when '남성'
      products.where("name LIKE ? OR description LIKE ?", '%남성%', '%남자%')
    when '여성'
      products.where("name LIKE ? OR description LIKE ?", '%여성%', '%여자%')
    when '키즈'
      products.where("name LIKE ? OR description LIKE ?", '%키즈%', '%아동%')
    when '상의'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%니트%', '%티셔츠%', '%셔츠%', '%상의%', '%블라우스%', '%스웨터%')
    when '아우터'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ?", 
                     '%재킷%', '%코트%', '%아우터%', '%자켓%')
    when '잡화'
      products.where("name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%스카프%', '%가방%', '%액세서리%', '%잡화%')
    else
      products
    end
  end

  def filter_book_subcategory(products, subcategory)
    case subcategory
    when '소설'
      products.where("name LIKE ? OR description LIKE ?", '%소설%', '%novel%')
    when '자기계발'
      products.where("name LIKE ? OR description LIKE ?", '%자기계발%', '%성공%')
    when '전문서적'
      products.where("name LIKE ? OR name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%프로그래밍%', '%개발%', '%웹%', '%전문%', '%기술%')
    when '만화'
      products.where("name LIKE ? OR description LIKE ?", '%만화%', '%웹툰%')
    else
      products
    end
  end

  def filter_lifestyle_subcategory(products, subcategory)
    case subcategory
    when '주방용품'
      products.where("name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%텀블러%', '%컵%', '%주방%', '%요리%')
    when '욕실용품'
      products.where("name LIKE ? OR description LIKE ?", '%욕실%', '%목욕%')
    when '인테리어'
      products.where("name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%디퓨저%', '%향%', '%인테리어%', '%꾸미기%')
    when '스포츠/헬스'
      products.where("name LIKE ? OR name LIKE ? OR description LIKE ? OR description LIKE ?", 
                     '%요가%', '%매트%', '%운동%', '%스포츠%')
    when '청소용품'
      products.where("name LIKE ? OR description LIKE ?", '%청소%', '%세제%')
    else
      products
    end
  end
end
