class MakeCategoryIdNullableInExpenses < ActiveRecord::Migration[8.0]
  def change
    change_column_null :expenses, :category_id, true
  end
end
