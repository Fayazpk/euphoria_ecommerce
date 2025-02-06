require "application_system_test_case"

class Admin::CouponsTest < ApplicationSystemTestCase
  setup do
    @admin_coupon = admin_coupons(:one)
  end

  test "visiting the index" do
    visit admin_coupons_url
    assert_selector "h1", text: "Coupons"
  end

  test "should create coupon" do
    visit admin_coupons_url
    click_on "New coupon"

    fill_in "Code", with: @admin_coupon.code
    fill_in "Description", with: @admin_coupon.description
    fill_in "Discount", with: @admin_coupon.discount
    fill_in "Max usage", with: @admin_coupon.max_usage
    fill_in "Minimum purchase amount", with: @admin_coupon.minimum_purchase_amount
    check "Status" if @admin_coupon.status
    fill_in "Valid from", with: @admin_coupon.valid_from
    fill_in "Valid until", with: @admin_coupon.valid_until
    click_on "Create Coupon"

    assert_text "Coupon was successfully created"
    click_on "Back"
  end

  test "should update Coupon" do
    visit admin_coupon_url(@admin_coupon)
    click_on "Edit this coupon", match: :first

    fill_in "Code", with: @admin_coupon.code
    fill_in "Description", with: @admin_coupon.description
    fill_in "Discount", with: @admin_coupon.discount
    fill_in "Max usage", with: @admin_coupon.max_usage
    fill_in "Minimum purchase amount", with: @admin_coupon.minimum_purchase_amount
    check "Status" if @admin_coupon.status
    fill_in "Valid from", with: @admin_coupon.valid_from
    fill_in "Valid until", with: @admin_coupon.valid_until
    click_on "Update Coupon"

    assert_text "Coupon was successfully updated"
    click_on "Back"
  end

  test "should destroy Coupon" do
    visit admin_coupon_url(@admin_coupon)
    click_on "Destroy this coupon", match: :first

    assert_text "Coupon was successfully destroyed"
  end
end
