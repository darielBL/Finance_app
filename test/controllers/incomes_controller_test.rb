require "test_helper"

class IncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "inc_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    @income = Income.create!(
      name: "Salary",
      amount_cents: 100000,
      amount_currency: "CUP",
      source: "Employer",
      user: @user
    )
  end

  teardown do
    IncomeRecord.destroy_all
    Income.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get incomes_path
    assert_response :success
  end

  test "should get new" do
    get new_income_path
    assert_response :success
  end

  test "should create income" do
    assert_difference("Income.count", 1) do
      post incomes_path, params: {
        income: { name: "Freelance", amount_cents: 50000, amount_currency: "CUP", source: "Client" }
      }
    end
    assert_redirected_to incomes_path
  end

  test "should not create income with invalid data" do
    assert_no_difference("Income.count") do
      post incomes_path, params: { income: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_income_path(@income)
    assert_response :success
  end

  test "should update income" do
    patch income_path(@income), params: { income: { name: "Updated Salary" } }
    assert_redirected_to incomes_path
    assert_equal "Updated Salary", @income.reload.name
  end

  test "should destroy income" do
    assert_difference("Income.count", -1) do
      delete income_path(@income)
    end
    assert_redirected_to incomes_path
  end
end
