class CreateSourceTransfers < ActiveRecord::Migration[8.0]
  def change
    create_table :source_transfers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :from_source, null: false
      t.string :to_source, null: false
      t.integer :amount_cents, null: false
      t.string :amount_currency, null: false, default: "CUP"
      t.date :transferred_at, null: false
      t.text :notes

      t.timestamps
    end
  end
end
