require "test_helper"

class Admin::SubcategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_subcategory = admin_subcategories(:one)
  end

  test "should get index" do
    get admin_subcategories_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_subcategory_url
    assert_response :success
  end

  test "should create admin_subcategory" do
    assert_difference("Admin::Subcategory.count") do
      post admin_subcategories_url, params: { admin_subcategory: { category_id: @admin_subcategory.category_id, description: @admin_subcategory.description, name: @admin_subcategory.name } }
    end

    assert_redirected_to admin_subcategory_url(Admin::Subcategory.last)
  end

  test "should show admin_subcategory" do
    get admin_subcategory_url(@admin_subcategory)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_subcategory_url(@admin_subcategory)
    assert_response :success
  end

  test "should update admin_subcategory" do
    patch admin_subcategory_url(@admin_subcategory), params: { admin_subcategory: { category_id: @admin_subcategory.category_id, description: @admin_subcategory.description, name: @admin_subcategory.name } }
    assert_redirected_to admin_subcategory_url(@admin_subcategory)
  end

  test "should destroy admin_subcategory" do
    assert_difference("Admin::Subcategory.count", -1) do
      delete admin_subcategory_url(@admin_subcategory)
    end

    assert_redirected_to admin_subcategories_url
  end
end
