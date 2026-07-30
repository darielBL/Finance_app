require "test_helper"

class GoalContributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "gc_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    @goal = Goal.create!(
      name: "Test Goal",
      target_amount_cents: 100000,
      target_amount_currency: "CUP",
      user: @user
    )
  end

  teardown do
    GoalContribution.destroy_all
    Goal.destroy_all
    User.destroy_all
  end

  test "should get new" do
    get new_goal_goal_contribution_path(@goal)
    assert_response :success
  end

  test "should create contribution" do
    assert_difference("GoalContribution.count", 1) do
      post goal_goal_contributions_path(@goal), params: {
        goal_contribution: { amount_cents: 25000, amount_currency: "CUP", contributed_at: Date.current }
      }
    end
    assert_redirected_to goal_path(@goal)
  end

  test "should not create contribution with invalid data" do
    assert_no_difference("GoalContribution.count") do
      post goal_goal_contributions_path(@goal), params: {
        goal_contribution: { amount_cents: 0, contributed_at: Date.current }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    contribution = @goal.contributions.create!(amount_cents: 10000, amount_currency: "CUP", contributed_at: Date.current)
    get edit_goal_goal_contribution_path(@goal, contribution)
    assert_response :success
  end

  test "should update contribution" do
    contribution = @goal.contributions.create!(amount_cents: 10000, amount_currency: "CUP", contributed_at: Date.current)
    patch goal_goal_contribution_path(@goal, contribution), params: {
      goal_contribution: { amount_cents: 20000 }
    }
    assert_redirected_to goal_path(@goal)
    assert_equal 20000, contribution.reload.amount_cents
  end

  test "should destroy contribution" do
    contribution = @goal.contributions.create!(amount_cents: 10000, amount_currency: "CUP", contributed_at: Date.current)
    assert_difference("GoalContribution.count", -1) do
      delete goal_goal_contribution_path(@goal, contribution)
    end
    assert_redirected_to goal_path(@goal)
  end
end
