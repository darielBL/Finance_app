class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :target_amount_cents, null: false
      t.string :target_amount_currency, null: false, default: "CUP"
      t.date :deadline
      t.text :description
      t.string :status, null: false, default: "in_progress"
      t.string :source

      t.timestamps
    end
  end
end
