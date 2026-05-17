class AddReceivedDateToRecurringIncomeRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :recurring_income_records, :received_date, :date
  end
end
