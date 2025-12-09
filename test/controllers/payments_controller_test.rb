require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get checkout" do
    get payments_checkout_url
    assert_response :success
  end

  test "should get success" do
    get payments_success_url
    assert_response :success
  end

  test "should get fail" do
    get payments_fail_url
    assert_response :success
  end

  test "should get confirm" do
    get payments_confirm_url
    assert_response :success
  end
end
