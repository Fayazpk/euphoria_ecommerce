require "application_system_test_case"

class Admin::SubcategoriesTest < ApplicationSystemTestCase
  setup do
    @admin_subcategory = admin_subcategories(:one)
  end

  test "visiting the index" do
    visit admin_subcategories_url
    assert_selector "h1", text: "Subcategories"
  end

  test "should create subcategory" do
    visit admin_subcategories_url
    click_on "New subcategory"

    fill_in "Category", with: @admin_subcategory.category_id
    fill_in "Description", with: @admin_subcategory.description
    fill_in "Name", with: @admin_subcategory.name
    click_on "Create Subcategory"

    assert_text "Subcategory was successfully created"
    click_on "Back"
  end

  test "should update Subcategory" do
    visit admin_subcategory_url(@admin_subcategory)
    click_on "Edit this subcategory", match: :first

    fill_in "Category", with: @admin_subcategory.category_id
    fill_in "Description", with: @admin_subcategory.description
    fill_in "Name", with: @admin_subcategory.name
    click_on "Update Subcategory"

    assert_text "Subcategory was successfully updated"
    click_on "Back"
  end

  test "should destroy Subcategory" do
    visit admin_subcategory_url(@admin_subcategory)
    click_on "Destroy this subcategory", match: :first

    assert_text "Subcategory was successfully destroyed"
  end
end
