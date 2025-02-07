require "application_system_test_case"

class Usermodule::AddressesTest < ApplicationSystemTestCase
  setup do
    @usermodule_address = usermodule_addresses(:one)
  end

  test "visiting the index" do
    visit usermodule_addresses_url
    assert_selector "h1", text: "Addresses"
  end

  test "should create address" do
    visit usermodule_addresses_url
    click_on "New address"

    fill_in "Building name", with: @usermodule_address.building_name
    fill_in "City name", with: @usermodule_address.city_name
    fill_in "Country name", with: @usermodule_address.country_name
    fill_in "First name", with: @usermodule_address.first_name
    fill_in "Last name", with: @usermodule_address.last_name
    fill_in "Phone", with: @usermodule_address.phone
    fill_in "State name", with: @usermodule_address.state_name
    fill_in "Street address", with: @usermodule_address.street_address
    fill_in "User", with: @usermodule_address.user_id
    click_on "Create Address"

    assert_text "Address was successfully created"
    click_on "Back"
  end

  test "should update Address" do
    visit usermodule_address_url(@usermodule_address)
    click_on "Edit this address", match: :first

    fill_in "Building name", with: @usermodule_address.building_name
    fill_in "City name", with: @usermodule_address.city_name
    fill_in "Country name", with: @usermodule_address.country_name
    fill_in "First name", with: @usermodule_address.first_name
    fill_in "Last name", with: @usermodule_address.last_name
    fill_in "Phone", with: @usermodule_address.phone
    fill_in "State name", with: @usermodule_address.state_name
    fill_in "Street address", with: @usermodule_address.street_address
    fill_in "User", with: @usermodule_address.user_id
    click_on "Update Address"

    assert_text "Address was successfully updated"
    click_on "Back"
  end

  test "should destroy Address" do
    visit usermodule_address_url(@usermodule_address)
    click_on "Destroy this address", match: :first

    assert_text "Address was successfully destroyed"
  end
end
