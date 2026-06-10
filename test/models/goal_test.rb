require "test_helper"

class GoalTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "goal_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @goal = Goal.new(
      name: "Test Goal",
      target_amount_cents: 100000,
      target_amount_currency: "CUP",
      deadline: Date.current + 6.months,
      user: @user
    )
  end

  teardown do
    GoalContribution.destroy_all
    Goal.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @goal.valid?
  end

  test "name should be present" do
    @goal.name = ""
    assert_not @goal.valid?
    assert @goal.errors[:name].any?
  end

  test "target_amount should be greater than 0" do
    @goal.target_amount_cents = 0
    assert_not @goal.valid?
    assert @goal.errors[:target_amount_cents].any?
  end

  test "status should be valid" do
    @goal.status = "invalid"
    assert_not @goal.valid?
    assert @goal.errors[:status].any?
  end

  test "current_amount_cents sums contributions" do
    @goal.save!
    @goal.contributions.create!(amount_cents: 30000, amount_currency: "CUP", contributed_at: Date.current)
    @goal.contributions.create!(amount_cents: 20000, amount_currency: "CUP", contributed_at: Date.current)
    assert_equal 50000, @goal.current_amount_cents
  end

  test "progress_percentage returns correct value" do
    @goal.save!
    @goal.contributions.create!(amount_cents: 25000, amount_currency: "CUP", contributed_at: Date.current)
    assert_equal 25.0, @goal.progress_percentage
  end

  test "progress_percentage caps at 100" do
    @goal.save!
    @goal.contributions.create!(amount_cents: 200000, amount_currency: "CUP", contributed_at: Date.current)
    assert_equal 100.0, @goal.progress_percentage
  end

  test "progress_percentage returns 0 when target is 0" do
    @goal.target_amount_cents = 0
    assert_equal 0, @goal.progress_percentage
  end

  test "remaining_cents returns correct value" do
    @goal.save!
    @goal.contributions.create!(amount_cents: 30000, amount_currency: "CUP", contributed_at: Date.current)
    assert_equal 70000, @goal.remaining_cents
  end

  test "completed? returns true when current meets or exceeds target" do
    @goal.save!
    @goal.contributions.create!(amount_cents: 100000, amount_currency: "CUP", contributed_at: Date.current)
    assert @goal.completed?
  end

  test "in_progress? returns true when status is in_progress" do
    assert @goal.in_progress?
  end

  test "days_remaining returns nil without deadline" do
    @goal.deadline = nil
    assert_nil @goal.days_remaining
  end

  test "scopes filter correctly" do
    @goal.save!
    completed = Goal.create!(name: "Completed", target_amount_cents: 100, target_amount_currency: "CUP", status: "completed", user: @user)
    cancelled = Goal.create!(name: "Cancelled", target_amount_cents: 100, target_amount_currency: "CUP", status: "cancelled", user: @user)
    assert_includes Goal.in_progress, @goal
    assert_includes Goal.completed, completed
    assert_includes Goal.cancelled, cancelled
  end
end
