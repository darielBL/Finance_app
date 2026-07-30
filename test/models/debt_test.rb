require "test_helper"

class DebtTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "debt_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @debt = Debt.new(
      name: "Test Debt",
      debt_type: "to_pay",
      person_name: "John Doe",
      amount_cents: 50000,
      amount_currency: "CUP",
      due_date: Date.current + 30.days,
      user: @user
    )
  end

  teardown do
    Debt.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @debt.valid?
  end

  test "name should be present" do
    @debt.name = ""
    assert_not @debt.valid?
    assert @debt.errors[:name].any?
  end

  test "debt_type should be to_pay or to_receive" do
    @debt.debt_type = "invalid"
    assert_not @debt.valid?
    assert @debt.errors[:debt_type].any?
  end

  test "amount should be greater than 0" do
    @debt.amount_cents = 0
    assert_not @debt.valid?
    assert @debt.errors[:amount_cents].any?
  end

  test "person_name should be present" do
    @debt.person_name = ""
    assert_not @debt.valid?
    assert @debt.errors[:person_name].any?
  end

  test "to_pay scope" do
    to_pay = Debt.create!(name: "To Pay", debt_type: "to_pay", person_name: "A", amount_cents: 100, amount_currency: "CUP", user: @user)
    Debt.create!(name: "To Receive", debt_type: "to_receive", person_name: "B", amount_cents: 100, amount_currency: "CUP", user: @user)
    assert_includes Debt.to_pay, to_pay
    assert_equal 1, Debt.to_pay.count
  end

  test "pending scope" do
    pending = Debt.create!(name: "Pending", debt_type: "to_pay", person_name: "A", amount_cents: 100, amount_currency: "CUP", user: @user, paid_at: nil)
    Debt.create!(name: "Paid", debt_type: "to_pay", person_name: "B", amount_cents: 100, amount_currency: "CUP", user: @user, paid_at: Date.current)
    assert_includes Debt.pending, pending
    assert_equal 1, Debt.pending.count
  end

  test "paid? returns true when paid_at is present" do
    @debt.paid_at = Date.current
    assert @debt.paid?
  end

  test "status returns pagada when paid" do
    @debt.paid_at = Date.current
    assert_equal "pagada", @debt.status
  end

  test "status returns vencida when overdue" do
    @debt.due_date = Date.yesterday
    assert_equal "vencida", @debt.status
  end

  test "status returns pendiente when not paid and not overdue" do
    @debt.due_date = Date.current + 30.days
    assert_equal "pendiente", @debt.status
  end

  test "to_pay? returns true for to_pay type" do
    assert @debt.to_pay?
    assert_not @debt.to_receive?
  end

  test "to_receive? returns true for to_receive type" do
    @debt.debt_type = "to_receive"
    assert @debt.to_receive?
    assert_not @debt.to_pay?
  end
end
