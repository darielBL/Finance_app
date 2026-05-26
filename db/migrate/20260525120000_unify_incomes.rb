class UnifyIncomes < ActiveRecord::Migration[8.0]
  def up
    rename_table :income_sources, :incomes

    add_column :incomes, :recurring, :boolean, default: false, null: false
    add_column :incomes, :due_day, :integer
    add_column :incomes, :active, :boolean, default: true

    mapping = {}

    select_all("SELECT * FROM recurring_incomes").each do |ri|
      result = execute(
        "INSERT INTO incomes (name, amount_cents, amount_currency, source, user_id, recurring, due_day, created_at, updated_at) " \
        "VALUES (#{quote(ri['name'])}, #{ri['estimated_amount_cents'] || 'NULL'}, #{quote(ri['estimated_amount_currency'])}, " \
        "#{quote(ri['source'])}, #{ri['user_id']}, true, #{ri['due_day'] || 'NULL'}, " \
        "#{quote(ri['created_at'].to_s)}, #{quote(ri['updated_at'].to_s)}) RETURNING id"
      )
      new_id = result.first["id"]
      mapping[ri["id"]] = new_id
    end

    rename_table :recurring_income_records, :income_records

    add_column :income_records, :income_id, :bigint

    select_all("SELECT * FROM income_records WHERE recurring_income_id IS NOT NULL").each do |record|
      old_id = record["recurring_income_id"]
      new_id = mapping[old_id]
      if new_id
        execute("UPDATE income_records SET income_id = #{new_id} WHERE id = #{record['id']}")
      end
    end

    change_column_null :income_records, :income_id, false

    remove_column :income_records, :recurring_income_id

    add_foreign_key :income_records, :incomes
    add_index :income_records, :income_id

    remove_foreign_key :recurring_expense_records, :recurring_incomes
    remove_column :recurring_expense_records, :recurring_income_id

    drop_table :recurring_incomes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
