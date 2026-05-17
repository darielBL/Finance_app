require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
    assert @user.errors[:email].any?
  end

  test "password should be present" do
    @user.password = ""
    assert_not @user.valid?
    assert @user.errors[:password].any?
  end
end