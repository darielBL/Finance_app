require "test_helper"

class InvestmentTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "inv_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @investment = Investment.new(
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

  test "should be valid" do
    assert @investment.valid?
  end

  test "name should be present" do
    @investment.name = ""
    assert_not @investment.valid?
    assert @investment.errors[:name].any?
  end

  test "amount should be greater than 0" do
    @investment.amount_cents = 0
    assert_not @investment.valid?
    assert @investment.errors[:amount_cents].any?
  end

  test "invested_at should be present" do
    @investment.invested_at = nil
    assert_not @investment.valid?
    assert @investment.errors[:invested_at].any?
  end

  test "invested_at should not be in future" do
    @investment.invested_at = Date.tomorrow
    assert_not @investment.valid?
    assert @investment.errors[:invested_at].any?
  end

  test "formatted_date returns correct format" do
    @investment.invested_at = Date.new(2026, 1, 15)
    assert_equal "15/01/2026", @investment.formatted_date
  end
end
