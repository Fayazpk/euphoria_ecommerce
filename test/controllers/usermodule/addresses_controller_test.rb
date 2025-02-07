require "test_helper"

class Usermodule::AddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usermodule_address = usermodule_addresses(:one)
  end

  test "should get index" do
    get usermodule_addresses_url
    assert_response :success
  end

  test "should get new" do
    get new_usermodule_address_url
    assert_response :success
  end

  test "should create usermodule_address" do
    assert_difference("Usermodule::Address.count") do
      post usermodule_addresses_url, params: { usermodule_address: { building_name: @usermodule_address.building_name, city_name: @usermodule_address.city_name, country_name: @usermodule_address.country_name, first_name: @usermodule_address.first_name, last_name: @usermodule_address.last_name, phone: @usermodule_address.phone, state_name: @usermodule_address.state_name, street_address: @usermodule_address.street_address, user_id: @usermodule_address.user_id } }
    end

    assert_redirected_to usermodule_address_url(Usermodule::Address.last)
  end

  test "should show usermodule_address" do
    get usermodule_address_url(@usermodule_address)
    assert_response :success
  end

  test "should get edit" do
    get edit_usermodule_address_url(@usermodule_address)
    assert_response :success
  end

  test "should update usermodule_address" do
    patch usermodule_address_url(@usermodule_address), params: { usermodule_address: { building_name: @usermodule_address.building_name, city_name: @usermodule_address.city_name, country_name: @usermodule_address.country_name, first_name: @usermodule_address.first_name, last_name: @usermodule_address.last_name, phone: @usermodule_address.phone, state_name: @usermodule_address.state_name, street_address: @usermodule_address.street_address, user_id: @usermodule_address.user_id } }
    assert_redirected_to usermodule_address_url(@usermodule_address)
  end

  test "should destroy usermodule_address" do
    assert_difference("Usermodule::Address.count", -1) do
      delete usermodule_address_url(@usermodule_address)
    end

    assert_redirected_to usermodule_addresses_url
  end
end
