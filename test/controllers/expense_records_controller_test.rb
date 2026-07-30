require "test_helper"

class ExpenseRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "er_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    @category = Category.create!(name: "Test", user: @user)
    @income = Income.create!(name: "Salary", amount_cents: 100000, amount_currency: "CUP", user_id: @user.id, source: "Work", active: true)
    @expense = Expense.create!(
      name: "Rent",
      amount_cents: 30000,
      amount_currency: "CUP",
      spent_at: Date.current,
      user: @user,
      category: @category,
      recurring: true,
      income_source_id: @income.id
    )
  end

  teardown do
    ExpenseRecord.destroy_all
    Expense.destroy_all
    Category.destroy_all
    User.destroy_all
  end

  test "should get new" do
    get new_expense_expense_record_path(@expense)
    assert_response :success
  end

  test "should create expense record" do
    assert_difference("ExpenseRecord.count", 1) do
      post expense_expense_records_path(@expense), params: {
        expense_record: { actual_amount_cents: 30000, actual_amount_currency: "CUP", paid_date: Date.current, income_source_id: @income.id }
      }
    end
    assert_redirected_to expenses_path
  end

  test "should get edit" do
    record = @expense.records.create!(
      month: Date.current.beginning_of_month,
      actual_amount_cents: 30000,
      actual_amount_currency: "CUP",
      paid_date: Date.current,
      income_source_id: @income.id
    )
    get edit_expense_record_path(record)
    assert_response :success
  end

  test "should update expense record" do
    record = @expense.records.create!(
      month: Date.current.beginning_of_month,
      actual_amount_cents: 30000,
      actual_amount_currency: "CUP",
      paid_date: Date.current,
      income_source_id: @income.id
    )
    patch expense_record_path(record), params: {
      expense_record: { actual_amount_cents: 35000, notes: "Updated" }
    }
    assert_redirected_to expenses_path
    assert_equal 35000, record.reload.actual_amount_cents
  end
end
