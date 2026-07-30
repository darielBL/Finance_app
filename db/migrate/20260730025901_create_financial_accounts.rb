class CreateFinancialAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :account_type, null: false, default: "other"
      t.string :color, default: "#6c757d"
      t.datetime :archived_at

      t.timestamps
    end
  end
end
