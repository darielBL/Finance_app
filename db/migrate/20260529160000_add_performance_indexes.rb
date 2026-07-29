class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # Índices compuestos para incomes - usado en dashboard (recurring, active, amount_currency)
    add_index :incomes, %i[user_id recurring active amount_currency],
              name: "idx_incomes_perf_dashboard"
    add_index :incomes, %i[user_id recurring],
              name: "idx_incomes_recurring_list"

    # Índices compuestos para expenses - usado en dashboard (recurring, spent_at, amount_currency)
    add_index :expenses, %i[user_id recurring spent_at amount_currency],
              name: "idx_expenses_perf_dashboard"
    add_index :expenses, %i[user_id recurring],
              name: "idx_expenses_recurring_list"

    # Índices para expense_records
    add_index :expense_records, %i[expense_id actual_amount_currency],
              name: "idx_expense_records_currency"
    add_index :expense_records, :paid_date,
              name: "idx_expense_records_paid_date"

    # Índices para income_records
    add_index :income_records, %i[income_id actual_amount_currency],
              name: "idx_income_records_currency"
    add_index :income_records, :received_date,
              name: "idx_income_records_received_date"

    # Índices para source_transfers
    add_index :source_transfers, %i[user_id transferred_at amount_currency],
              name: "idx_source_transfers_perf"
  end
end