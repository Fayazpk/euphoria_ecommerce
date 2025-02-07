require "test_helper"

class Usermodule::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get usermodule_orders_index_url
    assert_response :success
  end

  test "should get show" do
    get usermodule_orders_show_url
    assert_response :success
  end

  test "should get update_address" do
    get usermodule_orders_update_address_url
    assert_response :success
  end

  test "should get return_item" do
    get usermodule_orders_return_item_url
    assert_response :success
  end
end
