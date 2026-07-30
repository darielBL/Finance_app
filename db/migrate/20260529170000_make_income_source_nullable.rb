class MakeIncomeSourceNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :expenses, :income_source_id, true
    change_column_null :expense_records, :income_source_id, true
  end
end