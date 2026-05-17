class AddIncomeSourceRefToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_reference :expenses, :income_source, null: true, foreign_key: true
  end
end
