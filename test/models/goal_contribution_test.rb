require "test_helper"

class GoalContributionTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "gc_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @goal = Goal.create!(
      name: "Test Goal",
      target_amount_cents: 100000,
      target_amount_currency: "CUP",
      user: @user
    )
    @contribution = GoalContribution.new(
      goal: @goal,
      amount_cents: 50000,
      amount_currency: "CUP",
      contributed_at: Date.current
    )
  end

  teardown do
    GoalContribution.destroy_all
    Goal.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @contribution.valid?
  end

  test "amount should be greater than 0" do
    @contribution.amount_cents = 0
    assert_not @contribution.valid?
    assert @contribution.errors[:amount_cents].any?
  end

  test "contributed_at should be present" do
    @contribution.contributed_at = nil
    assert_not @contribution.valid?
    assert @contribution.errors[:contributed_at].any?
  end
end
