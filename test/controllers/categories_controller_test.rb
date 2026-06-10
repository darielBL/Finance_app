require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "cat_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
  end

  teardown do
    Category.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get categories_path
    assert_response :success
  end

  test "should get new" do
    get new_category_path
    assert_response :success
  end

  test "should create category" do
    assert_difference("Category.count", 1) do
      post categories_path, params: { category: { name: "New Category" } }
    end
    assert_redirected_to categories_path
  end

  test "should not create category with invalid data" do
    assert_no_difference("Category.count") do
      post categories_path, params: { category: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    category = Category.create!(name: "Test", user: @user)
    get edit_category_path(category)
    assert_response :success
  end

  test "should update category" do
    category = Category.create!(name: "Test", user: @user)
    patch category_path(category), params: { category: { name: "Updated" } }
    assert_redirected_to categories_path
    assert_equal "Updated", category.reload.name
  end

  test "should soft delete category" do
    category = Category.create!(name: "Test", user: @user)
    delete category_path(category)
    assert_redirected_to categories_path
    assert_not_nil category.reload.deleted_at
  end

  test "should not delete base category" do
    category = Category.create!(name: "Base", user_id: nil)
    delete category_path(category)
    assert_redirected_to categories_path
    assert_nil category.reload.deleted_at
  end
end
