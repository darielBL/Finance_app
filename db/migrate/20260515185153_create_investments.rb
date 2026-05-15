class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :investments do |t|
      t.string :name
      t.integer :amount_cents
      t.string :amount_currency
      t.date :invested_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
