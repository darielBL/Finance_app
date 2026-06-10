require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "redirects to sign in when not authenticated" do
    get root_path
    assert_redirected_to new_user_session_path
  end

  test "redirects to dashboard when authenticated" do
    user = User.create!(
      email: "home_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(user, scope: :user)
    get root_path
    assert_redirected_to dashboard_path
  end
end
