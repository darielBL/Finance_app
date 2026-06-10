require "test_helper"

class InvestmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "inv_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    @investment = Investment.create!(
      name: "Test Investment",
      amount_cents: 500000,
      amount_currency: "CUP",
      invested_at: Date.current,
      user: @user
    )
  end

  teardown do
    Investment.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get investments_path
    assert_response :success
  end

  test "should get new" do
    get new_investment_path
    assert_response :success
  end

  test "should create investment" do
    assert_difference("Investment.count", 1) do
      post investments_path, params: {
        investment: { name: "New Investment", amount_cents: 100000, amount_currency: "CUP", invested_at: Date.current }
      }
    end
    assert_redirected_to investments_path
  end

  test "should not create investment with invalid data" do
    assert_no_difference("Investment.count") do
      post investments_path, params: { investment: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_investment_path(@investment)
    assert_response :success
  end

  test "should update investment" do
    patch investment_path(@investment), params: { investment: { name: "Updated" } }
    assert_redirected_to investments_path
    assert_equal "Updated", @investment.reload.name
  end

  test "should destroy investment" do
    assert_difference("Investment.count", -1) do
      delete investment_path(@investment)
    end
    assert_redirected_to investments_path
  end
end
