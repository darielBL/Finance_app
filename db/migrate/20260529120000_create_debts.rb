class CreateDebts < ActiveRecord::Migration[8.0]
  def change
    create_table :debts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :debt_type, null: false
      t.string :person_name
      t.integer :amount_cents
      t.string :amount_currency
      t.date :due_date
      t.date :paid_at
      t.text :notes
      t.timestamps
    end

    add_index :debts, [:user_id, :debt_type]
    add_index :debts, [:user_id, :paid_at]
  end
end
