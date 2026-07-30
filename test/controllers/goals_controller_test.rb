require "test_helper"

class GoalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "goal_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
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

  test "should get index" do
    get goals_path
    assert_response :success
  end

  test "should get new" do
    get new_goal_path
    assert_response :success
  end

  test "should create goal" do
    assert_difference("Goal.count", 1) do
      post goals_path, params: {
        goal: { name: "New Goal", target_amount_cents: 50000, target_amount_currency: "CUP" }
      }
    end
    assert_redirected_to goals_path
  end

  test "should not create goal with invalid data" do
    assert_no_difference("Goal.count") do
      post goals_path, params: { goal: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should show goal" do
    get goal_path(@goal)
    assert_response :success
  end

  test "should get edit" do
    get edit_goal_path(@goal)
    assert_response :success
  end

  test "should update goal" do
    patch goal_path(@goal), params: { goal: { name: "Updated Goal" } }
    assert_redirected_to goals_path
    assert_equal "Updated Goal", @goal.reload.name
  end

  test "should destroy goal" do
    assert_difference("Goal.count", -1) do
      delete goal_path(@goal)
    end
    assert_redirected_to goals_path
  end
end
