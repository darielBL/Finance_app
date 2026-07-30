class AddTargetAccountToGoals < ActiveRecord::Migration[8.0]
  def change
    add_reference :goals, :target_account, null: true, foreign_key: { to_table: :financial_accounts }
    remove_column :goals, :source, :string
  end
end
