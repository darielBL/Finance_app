class AddSourceToRecurringIncomes < ActiveRecord::Migration[8.0]
  def change
    add_column :recurring_incomes, :source, :string
  end
end
