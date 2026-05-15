class CreateIncomeSources < ActiveRecord::Migration[8.0]
  def change
    create_table :income_sources do |t|
      t.string :name
      t.integer :amount_cents
      t.string :amount_currency
      t.string :payment_method
      t.string :payment_method_detail
      t.string :frequency
      t.boolean :active
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
