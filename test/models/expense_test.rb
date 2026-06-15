require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @category = Category.create!(name: "Test Category", user_id: @user.id)
    @income = Income.create!(name: "Salary", amount_cents: 100000, amount_currency: "CUP", user_id: @user.id, source: "Work", active: true)
    @expense = Expense.new(
      name: "Test Expense",
      amount_cents: 10000,
      amount_currency: "CUP",
      spent_at: Date.current,
      category_id: @category.id,
      user_id: @user.id,
      income_source_id: @income.id
    )
  end

  teardown do
    Expense.destroy_all
    Category.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @expense.valid?
  end

  test "name should be present" do
    @expense.name = ""
    assert_not @expense.valid?
    assert @expense.errors[:name].any?
  end

  test "amount should be greater than 0" do
    @expense.amount_cents = 0
    assert_not @expense.valid?
    assert @expense.errors[:amount_cents].any?
  end

  test "should not allow future date" do
    valid_expense = Expense.new(
      name: "Test",
      amount_cents: 10000,
      amount_currency: "CUP",
      spent_at: Date.current,
      category_id: @category.id,
      user_id: @user.id,
      income_source_id: @income.id
    )

    puts "=== DEBUG ==="
    puts "1. Base expense valid? #{valid_expense.valid?}"
    puts "Errors: #{valid_expense.errors.full_messages}" unless valid_expense.valid?

    valid_expense.spent_at = Date.tomorrow
    puts "2. After setting future date: spent_at = #{valid_expense.spent_at}"
    puts "3. Valid? #{valid_expense.valid?}"
    puts "4. Errors: #{valid_expense.errors.full_messages}"
    puts "5. spent_at errors: #{valid_expense.errors[:spent_at]}"
    puts "================"

    assert_not valid_expense.valid?
    assert_includes valid_expense.errors[:spent_at], "no puede ser una fecha futura"
  end
end
