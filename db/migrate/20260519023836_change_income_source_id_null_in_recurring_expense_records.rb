class ChangeIncomeSourceIdNullInRecurringExpenseRecords < ActiveRecord::Migration[8.0]
  def change
    change_column_null :recurring_expense_records, :income_source_id, true
  end
end