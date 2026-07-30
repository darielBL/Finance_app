require "test_helper"

class DebtsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "debt_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    @debt = Debt.create!(
      name: "Test Debt",
      debt_type: "to_pay",
      person_name: "John",
      amount_cents: 50000,
      amount_currency: "CUP",
      user: @user
    )
  end

  teardown do
    Debt.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get debts_path
    assert_response :success
  end

  test "should get new" do
    get new_debt_path
    assert_response :success
  end

  test "should create debt" do
    assert_difference("Debt.count", 1) do
      post debts_path, params: {
        debt: { name: "New Debt", debt_type: "to_receive", person_name: "Jane", amount_cents: 30000, amount_currency: "CUP" }
      }
    end
    assert_redirected_to debts_path
  end

  test "should not create debt with invalid data" do
    assert_no_difference("Debt.count") do
      post debts_path, params: { debt: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_debt_path(@debt)
    assert_response :success
  end

  test "should update debt" do
    patch debt_path(@debt), params: { debt: { name: "Updated" } }
    assert_redirected_to debts_path
    assert_equal "Updated", @debt.reload.name
  end

  test "should destroy debt" do
    assert_difference("Debt.count", -1) do
      delete debt_path(@debt)
    end
    assert_redirected_to debts_path
  end

  test "should mark as paid" do
    patch mark_as_paid_debt_path(@debt)
    assert_redirected_to debts_path
    assert @debt.reload.paid?
  end

  test "should toggle paid status" do
    @debt.update(paid_at: Date.current)
    patch mark_as_paid_debt_path(@debt)
    assert_redirected_to debts_path
    assert_not @debt.reload.paid?
  end
end
