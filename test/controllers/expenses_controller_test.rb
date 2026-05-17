require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Crear usuario
    @user = User.create!(
      email: "test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    # Login manual con Warden (más confiable que sign_in)
    login_as(@user, scope: :user)

    # Crear categoría
    @category = Category.create!(name: "Test Category", user_id: @user.id)
  end

  teardown do
    # Limpiar en orden inverso
    Expense.destroy_all
    Category.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get expenses_path
    assert_response :success
  end

  test "should create expense" do
    assert_difference('Expense.count', 1) do
      post expenses_path, params: {
        expense: {
          description: "New Expense",
          normalized_amount: 100.00,
          amount_currency: "CUP",
          spent_at: Date.current,
          category_id: @category.id
        }
      }
    end
    assert_redirected_to expenses_path
  end

  test "should not create expense with invalid data" do
    assert_no_difference('Expense.count') do
      post expenses_path, params: {
        expense: {
          description: "",
          normalized_amount: -10,
          amount_currency: "CUP",
          spent_at: Date.current,
          category_id: @category.id
        }
      }
    end
  end
end