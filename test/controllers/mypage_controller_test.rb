require "test_helper"

class MypageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mypage_index_url
    assert_response :success
  end

  test "should get orders" do
    get mypage_orders_url
    assert_response :success
  end

  test "should get coupons" do
    get mypage_coupons_url
    assert_response :success
  end

  test "should get reviews" do
    get mypage_reviews_url
    assert_response :success
  end

  test "should get inquiries" do
    get mypage_inquiries_url
    assert_response :success
  end
end
