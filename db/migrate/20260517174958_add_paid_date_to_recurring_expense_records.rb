class AddPaidDateToRecurringExpenseRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :recurring_expense_records, :paid_date, :date
  end
end
