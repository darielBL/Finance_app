class MakeIncomeSourceIdRequired < ActiveRecord::Migration[8.0]
  def change
    # Asignar ingresos existentes a registros sin fuente
    Expense.where(income_source_id: nil).find_each do |expense|
      default_income = expense.user.incomes.order(:created_at).first
      if default_income
        expense.update_column(:income_source_id, default_income.id)
      end
    end

    ExpenseRecord.where(income_source_id: nil).find_each do |record|
      default_income = record.expense.user.incomes.order(:created_at).first
      if default_income
        record.update_column(:income_source_id, default_income.id)
      end
    end

    change_column_null :expenses, :income_source_id, false
    change_column_null :expense_records, :income_source_id, false
  end
end
