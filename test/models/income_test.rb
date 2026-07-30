require "test_helper"

class IncomeTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "income_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @income = Income.new(
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

  test "should be valid" do
    assert @income.valid?
  end

  test "name should be present" do
    @income.name = ""
    assert_not @income.valid?
    assert @income.errors[:name].any?
  end

  test "amount should be greater than 0" do
    @income.amount_cents = 0
    assert_not @income.valid?
    assert @income.errors[:amount_cents].any?
  end

  test "source should be present" do
    @income.source = ""
    assert_not @income.valid?
    assert @income.errors[:source].any?
  end

  test "due_day should be within 1..31" do
    @income.due_day = 32
    assert_not @income.valid?
    assert @income.errors[:due_day].any?
  end

  test "active scope" do
    @income.save!
    inactive = Income.create!(name: "Old", amount_cents: 100, amount_currency: "CUP", source: "Other", user: @user, active: false)
    assert_includes Income.active, @income
    assert_not_includes Income.active, inactive
  end

  test "unique? returns true when not recurring" do
    assert @income.unique?
    @income.recurring = true
    assert_not @income.unique?
  end

  test "recurring scope" do
    @income.update(recurring: true)
    @income.save!
    unique_income = Income.create!(name: "Unique", amount_cents: 100, amount_currency: "CUP", source: "Other", user: @user, recurring: false)
    assert_includes Income.recurring, @income
    assert_includes Income.unique, unique_income
  end

  test "current_month_record returns record for current month" do
    @income.save!
    record = @income.records.create!(month: Date.current.beginning_of_month, actual_amount_cents: 100000, actual_amount_currency: "CUP", received_date: Date.current)
    assert_equal record, @income.current_month_record
  end

  test "last_record returns most recent record" do
    @income.save!
    old = @income.records.create!(month: 2.months.ago.beginning_of_month, actual_amount_cents: 90000, actual_amount_currency: "CUP", received_date: 2.months.ago)
    recent = @income.records.create!(month: 1.month.ago.beginning_of_month, actual_amount_cents: 100000, actual_amount_currency: "CUP", received_date: 1.month.ago)
    assert_equal recent, @income.last_record
  end
end
