class CreateGoalContributions < ActiveRecord::Migration[8.0]
  def change
    create_table :goal_contributions do |t|
      t.references :goal, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :amount_currency, null: false, default: "CUP"
      t.date :contributed_at, null: false
      t.text :notes
      t.string :source

      t.timestamps
    end
  end
end
