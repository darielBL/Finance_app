class UnifyExpenses < ActiveRecord::Migration[8.0]
  def up
    add_column :expenses, :name, :string
    add_column :expenses, :recurring, :boolean, default: false, null: false
    add_column :expenses, :due_day, :integer

    execute("UPDATE expenses SET name = description WHERE name IS NULL")

    mapping = {}

    select_all("SELECT * FROM recurring_expenses").each do |re|
      result = execute(
        "INSERT INTO expenses (name, amount_cents, amount_currency, user_id, recurring, due_day, created_at, updated_at, category_id) " \
        "VALUES (#{quote(re['name'])}, #{re['estimated_amount_cents'] || 'NULL'}, #{quote(re['estimated_amount_currency'])}, " \
        "#{re['user_id']}, true, #{re['due_day'] || 'NULL'}, " \
        "#{quote(re['created_at'].to_s)}, #{quote(re['updated_at'].to_s)}, " \
        "(SELECT id FROM categories WHERE user_id = #{re['user_id']} LIMIT 1)) RETURNING id"
      )
      new_id = result.first["id"]
      mapping[re["id"]] = new_id
    end

    rename_table :recurring_expense_records, :expense_records

    add_column :expense_records, :expense_id, :bigint

    select_all("SELECT * FROM expense_records WHERE recurring_expense_id IS NOT NULL").each do |record|
      old_id = record["recurring_expense_id"]
      new_id = mapping[old_id]
      if new_id
        execute("UPDATE expense_records SET expense_id = #{new_id} WHERE id = #{record['id']}")
      end
    end

    change_column_null :expense_records, :expense_id, false

    remove_column :expense_records, :recurring_expense_id

    add_foreign_key :expense_records, :expenses
    add_index :expense_records, :expense_id

    drop_table :recurring_expenses
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
