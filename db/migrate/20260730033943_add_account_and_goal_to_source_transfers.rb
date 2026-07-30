class AddAccountAndGoalToSourceTransfers < ActiveRecord::Migration[8.0]
  def change
    add_reference :source_transfers, :from_account, null: true, foreign_key: { to_table: :financial_accounts }
    add_reference :source_transfers, :to_account, null: true, foreign_key: { to_table: :financial_accounts }
    add_reference :source_transfers, :goal, null: true, foreign_key: true
  end
end
