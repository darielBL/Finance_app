require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "dash_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
  end

  teardown do
    User.destroy_all
  end

  test "should get index" do
    get dashboard_path
    assert_response :success
  end
end
