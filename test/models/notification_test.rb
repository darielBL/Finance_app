require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "notif_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
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
    @notification = Notification.new(
      user: @user,
      notifiable: @income,
      notification_type: "pending",
      title: "Pending income",
      message: "Record income for this month"
    )
  end

  teardown do
    Notification.destroy_all
    Income.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @notification.valid?
  end

  test "notification_type should be present" do
    @notification.notification_type = ""
    assert_not @notification.valid?
    assert @notification.errors[:notification_type].any?
  end

  test "title should be present" do
    @notification.title = ""
    assert_not @notification.valid?
    assert @notification.errors[:title].any?
  end

  test "unread scope returns only unread notifications" do
    @notification.save!
    read_notif = Notification.create!(user: @user, notifiable: @income, notification_type: "pending", title: "Read", read: true)
    assert_includes Notification.unread, @notification
    assert_not_includes Notification.unread, read_notif
  end
end
