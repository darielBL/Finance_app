class AddDueDateToRecurringExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :recurring_expenses, :due_date, :date
  end
end
