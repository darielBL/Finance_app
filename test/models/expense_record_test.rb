require "test_helper"

class ExpenseRecordTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "er_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @expense = Expense.create!(
      name: "Rent",
      amount_cents: 30000,
      amount_currency: "CUP",
      spent_at: Date.current,
      user: @user
    )
    @record = ExpenseRecord.new(
      expense: @expense,
      month: Date.current.beginning_of_month,
      actual_amount_cents: 30000,
      actual_amount_currency: "CUP",
      paid_date: Date.current
    )
  end

  teardown do
    ExpenseRecord.destroy_all
    Expense.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @record.valid?
  end

  test "month should be present" do
    @record.month = nil
    assert_not @record.valid?
    assert @record.errors[:month].any?
  end

  test "month should not be in future" do
    @record.month = Date.current.next_month.beginning_of_month
    assert_not @record.valid?
    assert @record.errors[:month].any?
  end

  test "sets currency from parent before save" do
    @record.actual_amount_currency = nil
    @record.save!
    assert_equal "CUP", @record.actual_amount_currency
  end
end
