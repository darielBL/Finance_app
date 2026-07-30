require "test_helper"

class IncomeRecordTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "ir_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @income = Income.create!(
      name: "Salary",
      amount_cents: 100000,
      amount_currency: "CUP",
      source: "Employer",
      user: @user
    )
    @record = IncomeRecord.new(
      income: @income,
      month: Date.current.beginning_of_month,
      actual_amount_cents: 100000,
      actual_amount_currency: "CUP",
      received_date: Date.current
    )
  end

  teardown do
    IncomeRecord.destroy_all
    Income.destroy_all
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

  test "received_date should be present" do
    @record.received_date = nil
    assert_not @record.valid?
    assert @record.errors[:received_date].any?
  end

  test "month should not be in future" do
    @record.month = Date.current.next_month.beginning_of_month
    assert_not @record.valid?
    assert @record.errors[:month].any?
  end

  test "received_date should not be in future" do
    @record.received_date = Date.tomorrow
    assert_not @record.valid?
    assert @record.errors[:received_date].any?
  end

  test "sets currency from parent before save" do
    @record.actual_amount_currency = nil
    @record.save!
    assert_equal "CUP", @record.actual_amount_currency
  end

  test "difference_cents returns actual minus expected" do
    @record.save!
    assert_equal 0, @record.difference_cents
  end

  test "for_month scope" do
    @record.save!
    result = IncomeRecord.for_month(Date.current)
    assert_includes result, @record
  end
end
