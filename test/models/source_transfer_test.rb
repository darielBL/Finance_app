require "test_helper"

class SourceTransferTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      email: "st_test_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    @transfer = SourceTransfer.new(
      user: @user,
      from_source: "Bank A",
      to_source: "Bank B",
      amount_cents: 50000,
      amount_currency: "CUP",
      transferred_at: Date.current
    )
  end

  teardown do
    SourceTransfer.destroy_all
    User.destroy_all
  end

  test "should be valid" do
    assert @transfer.valid?
  end

  test "from_source should be present" do
    @transfer.from_source = ""
    assert_not @transfer.valid?
    assert @transfer.errors[:from_source].any?
  end

  test "to_source should be present" do
    @transfer.to_source = ""
    assert_not @transfer.valid?
    assert @transfer.errors[:to_source].any?
  end

  test "amount should be greater than 0" do
    @transfer.amount_cents = 0
    assert_not @transfer.valid?
    assert @transfer.errors[:amount_cents].any?
  end

  test "transferred_at should be present" do
    @transfer.transferred_at = nil
    assert_not @transfer.valid?
    assert @transfer.errors[:transferred_at].any?
  end

  test "sources must differ" do
    @transfer.to_source = "Bank A"
    assert_not @transfer.valid?
    assert @transfer.errors[:to_source].any?
  end
end
