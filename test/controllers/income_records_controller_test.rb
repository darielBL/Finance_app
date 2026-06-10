require "test_helper"

class IncomeRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "ir_controller_#{Time.now.to_i}_#{rand(1000)}@example.com",
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
  end

  teardown do
    IncomeRecord.destroy_all
    Income.destroy_all
    User.destroy_all
  end

  test "should get new" do
    get new_income_income_record_path(@income)
    assert_response :success
  end

  test "should create income record" do
    assert_difference("IncomeRecord.count", 1) do
      post income_income_records_path(@income), params: {
        income_record: { actual_amount_cents: 100000, actual_amount_currency: "CUP", received_date: Date.current }
      }
    end
    assert_redirected_to incomes_path
  end

  test "should not create income record with invalid data" do
    assert_no_difference("IncomeRecord.count") do
      post income_income_records_path(@income), params: {
        income_record: { received_date: nil }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    record = @income.records.create!(
      month: Date.current.beginning_of_month,
      actual_amount_cents: 100000,
      actual_amount_currency: "CUP",
      received_date: Date.current
    )
    get edit_income_record_path(record)
    assert_response :success
  end

  test "should update income record" do
    record = @income.records.create!(
      month: Date.current.beginning_of_month,
      actual_amount_cents: 100000,
      actual_amount_currency: "CUP",
      received_date: Date.current
    )
    patch income_record_path(record), params: {
      income_record: { actual_amount_cents: 110000 }
    }
    assert_redirected_to incomes_path
    assert_equal 110000, record.reload.actual_amount_cents
  end
end
