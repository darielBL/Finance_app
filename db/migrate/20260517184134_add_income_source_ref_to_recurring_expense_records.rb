class AddIncomeSourceRefToRecurringExpenseRecords < ActiveRecord::Migration[8.0]
  def change
    add_reference :recurring_expense_records, :income_source, null: false, foreign_key: true
  end
end
