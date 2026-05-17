class CreateRecurringExpenseRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :recurring_expense_records do |t|
      t.references :recurring_expense, null: false, foreign_key: true
      t.date :month
      t.integer :actual_amount_cents
      t.string :actual_amount_currency
      t.text :notes

      t.timestamps
    end
  end
end
