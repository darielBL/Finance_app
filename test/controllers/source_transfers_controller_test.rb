require "test_helper"

class SourceTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "st_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    login_as(@user, scope: :user)
    Income.create!(name: "Bank A", amount_cents: 100000, amount_currency: "CUP", source: "Bank A", user: @user)
    Income.create!(name: "Bank B", amount_cents: 100000, amount_currency: "CUP", source: "Bank B", user: @user)
    @transfer = SourceTransfer.create!(
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
    Income.destroy_all
    User.destroy_all
  end

  test "should get index" do
    get source_transfers_path
    assert_response :success
  end

  test "should get new" do
    get new_source_transfer_path
    assert_response :success
  end

  test "should create transfer" do
    assert_difference("SourceTransfer.count", 1) do
      post source_transfers_path, params: {
        source_transfer: { from_source: "Bank B", to_source: "Bank A", amount_cents: 25000, amount_currency: "CUP", transferred_at: Date.current }
      }
    end
    assert_redirected_to source_transfers_path
  end

  test "should not create transfer with invalid data" do
    assert_no_difference("SourceTransfer.count") do
      post source_transfers_path, params: { source_transfer: { from_source: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_source_transfer_path(@transfer)
    assert_response :success
  end

  test "should update transfer" do
    patch source_transfer_path(@transfer), params: { source_transfer: { amount_cents: 60000 } }
    assert_redirected_to source_transfers_path
    assert_equal 60000, @transfer.reload.amount_cents
  end

  test "should destroy transfer" do
    assert_difference("SourceTransfer.count", -1) do
      delete source_transfer_path(@transfer)
    end
    assert_redirected_to source_transfers_path
  end
end
