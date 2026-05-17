class CreateRecurringIncomes < ActiveRecord::Migration[8.0]
  def change
    create_table :recurring_incomes do |t|
      t.string :name
      t.integer :estimated_amount_cents
      t.string :estimated_amount_currency
      t.integer :due_day
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
