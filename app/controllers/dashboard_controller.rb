class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Filtros actuales
    @currency = params[:currency].presence || session[:currency].presence || "CUP"
    @period = params[:period].presence || session[:period].presence || "current_month"

    session[:currency] = @currency
    session[:period] = @period

    @date_range = case @period
                  when "current_month"
                    Date.current.beginning_of_month..Date.current.end_of_month
                  when "last_month"
                    (Date.current - 1.month).beginning_of_month..(Date.current - 1.month).end_of_month
                  when "last_3_months"
                    3.months.ago.beginning_of_month..Date.current.end_of_month
                  when "current_year"
                    Date.current.beginning_of_year..Date.current.end_of_year
                  else
                    Date.current.beginning_of_month..Date.current.end_of_month
                  end

    # ==========================================
    # GASTOS ÚNICOS
    # ==========================================
    @expenses = current_user.expenses.where(spent_at: @date_range, amount_currency: @currency)
    @expenses_by_category = @expenses.joins(:category)
                                     .group("categories.name")
                                     .sum(:amount_cents)
                                     .map { |category_name, cents| [category_name, cents.to_f / 100] }

    # ==========================================
    # GASTOS RECURRENTES REGISTRADOS (pagos reales del período)
    # ==========================================
    @recurring_expenses_paid = RecurringExpenseRecord.joins(:recurring_expense)
                                                     .where(recurring_expense: { user_id: current_user.id })
                                                     .where(paid_date: @date_range)
                                                     .where(actual_amount_currency: @currency)

    @total_recurring_paid = Money.new(@recurring_expenses_paid.sum(:actual_amount_cents), @currency)

    # ==========================================
    # TOTAL DE GASTOS (únicos + recurrentes registrados)
    # ==========================================
    @total_expenses = Money.new(
      @expenses.sum(:amount_cents) + @recurring_expenses_paid.sum(:actual_amount_cents),
      @currency
    )

    # ==========================================
    # GRÁFICO DE GASTOS POR CATEGORÍA (incluyendo recurrentes)
    # ==========================================
    @expenses_by_category_with_recurring = @expenses_by_category.dup
    if @total_recurring_paid.cents > 0
      @expenses_by_category_with_recurring << ["🔄 Gastos Recurrentes", @total_recurring_paid.cents.to_f / 100]
    end

    # ==========================================
    # GRÁFICO 1: Distribución de ingresos por origen (source)
    # ==========================================
    @income_by_account = current_user.income_sources
                                     .where(active: true)
                                     .where(amount_currency: @currency)
                                     .group(:source)
                                     .sum(:amount_cents)
                                     .map { |source, cents|
                                       label = source.present? ? source : "Otros"
                                       [label, cents.to_f / 100]
                                     }

    @total_income_by_account = Money.new(current_user.income_sources
                                                     .where(active: true)
                                                     .where(amount_currency: @currency)
                                                     .sum(:amount_cents), @currency)

    # ==========================================
    # INGRESOS RECURRENTES REGISTRADOS (cobros reales del período)
    # ==========================================
    @recurring_incomes_paid = RecurringIncomeRecord.joins(:recurring_income)
                                                   .where(recurring_income: { user_id: current_user.id })
                                                   .where(received_date: @date_range)
                                                   .where(actual_amount_currency: @currency)

    @total_recurring_income_paid = Money.new(@recurring_incomes_paid.sum(:actual_amount_cents), @currency)

    # ==========================================
    # INGRESOS ACTIVOS (únicos activos + recurrentes registrados)
    # ==========================================
    @active_income_sources = current_user.income_sources
                                         .where(active: true)
                                         .where(amount_currency: @currency)

    @total_active_income = Money.new(
      @active_income_sources.sum(:amount_cents) + @recurring_incomes_paid.sum(:actual_amount_cents),
      @currency
    )

    # ==========================================
    # SALDO INICIAL / CAPITAL EXISTENTE (ingresos inactivos)
    # ==========================================
    @capital_income_sources = current_user.income_sources
                                          .where(active: false)
                                          .where(amount_currency: @currency)

    @total_capital = Money.new(@capital_income_sources.sum(:amount_cents), @currency)

    # ==========================================
    # PATRIMONIO TOTAL = Capital Inicial + Ingresos Activos - Gastos Totales
    # ==========================================
    @total_wealth = @total_capital + @total_active_income - @total_expenses

    # ==========================================
    # ORIGEN DE LOS GASTOS (Ingresos + Capital Inicial)
    # ==========================================
    # 1. Gastos únicos vinculados a fuentes de ingreso activas
    expenses_from_income = current_user.expenses
                                       .where(spent_at: @date_range)
                                       .where(amount_currency: @currency)
                                       .where.not(income_source_id: nil)
                                       .joins(:income_source)
                                       .where("income_sources.active = ?", true)
                                       .group("income_sources.name")
                                       .sum(:amount_cents)
                                       .map { |name, cents| [name, cents.to_f / 100] }

    # 2. Gastos recurrentes vinculados a fuentes de ingreso activas
    recurring_from_income = RecurringExpenseRecord.joins(:recurring_expense)
                                                  .where(recurring_expense: { user_id: current_user.id })
                                                  .where(paid_date: @date_range)
                                                  .where(actual_amount_currency: @currency)
                                                  .where.not(income_source_id: nil)
                                                  .joins(:income_source)
                                                  .where("income_sources.active = ?", true)
                                                  .group("income_sources.name")
                                                  .sum(:actual_amount_cents)
                                                  .map { |name, cents| [name, cents.to_f / 100] }

    # 3. Gastos únicos NO vinculados (capital inicial)
    expenses_from_capital = current_user.expenses
                                        .where(spent_at: @date_range)
                                        .where(amount_currency: @currency)
                                        .where(income_source_id: nil)
                                        .sum(:amount_cents)

    # 4. Gastos recurrentes NO vinculados (capital inicial)
    recurring_from_capital = RecurringExpenseRecord.joins(:recurring_expense)
                                                   .where(recurring_expense: { user_id: current_user.id })
                                                   .where(paid_date: @date_range)
                                                   .where(actual_amount_currency: @currency)
                                                   .where(income_source_id: nil)
                                                   .sum(:actual_amount_cents)

    total_from_capital = expenses_from_capital + recurring_from_capital

    # Combinar todas las fuentes
    all_sources = {}
    expenses_from_income.each { |name, amount| all_sources[name] = amount }
    recurring_from_income.each { |name, amount| all_sources[name] = (all_sources[name] || 0) + amount }

    if total_from_capital > 0
      all_sources["💰 Capital Inicial (Ahorros)"] = total_from_capital.to_f / 100
    end

    @all_sources = all_sources

    # ==========================================
    # MONEDAS DISPONIBLES
    # ==========================================
    @available_currencies = (current_user.expenses.select(:amount_currency).distinct.pluck(:amount_currency) +
      current_user.income_sources.select(:amount_currency).distinct.pluck(:amount_currency) +
      current_user.recurring_expense_records.select(:actual_amount_currency).distinct.pluck(:actual_amount_currency) +
      current_user.recurring_income_records.select(:actual_amount_currency).distinct.pluck(:actual_amount_currency)).uniq
    @available_currencies = ["CUP"] if @available_currencies.empty?
  end
end