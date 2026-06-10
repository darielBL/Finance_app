require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "notif_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    @income = Income.create!(
      name: "Salary",
      amount_cents: 100000,
      amount_currency: "CUP",
      source: "Employer",
      user: @user
    )
    @notification = Notification.create!(
      user: @user,
      notifiable: @income,
      notification_type: "pending",
      title: "Pending income"
    )
  end

  teardown do
    Notification.destroy_all
    Income.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get notifications_path
    assert_response :success
  end

  test "should mark as read" do
    patch notification_path(@notification)
    assert @notification.reload.read
  end

  test "should mark all as read" do
    Notification.create!(user: @user, notifiable: @income, notification_type: "pending", title: "Another")
    patch mark_all_as_read_notifications_path
    assert_redirected_to notifications_path
    assert_equal 0, @user.notifications.unread.count
  end
end
