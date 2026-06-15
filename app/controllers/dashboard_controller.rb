class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
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
    @expenses = current_user.expenses.unique.where(spent_at: @date_range, amount_currency: @currency)
    @expenses_by_category = @expenses.joins(:category)
                                     .group("categories.name")
                                     .sum(:amount_cents)
                                     .map { |category_name, cents| [category_name, cents.to_f / 100] }

    # ==========================================
    # GASTOS RECURRENTES REGISTRADOS (pagos reales del período)
    # ==========================================
    @recurring_expenses_paid = ExpenseRecord.joins(:expense)
                                            .where(expense: { user_id: current_user.id })
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
    @income_by_account = current_user.incomes
                                     .where(active: true)
                                     .unique
                                     .where(amount_currency: @currency)
                                     .group(:source)
                                     .sum(:amount_cents)
                                     .map { |source, cents|
                                       label = source.present? ? source : "Otros"
                                       [label, cents.to_f / 100]
                                     }

    @total_income_by_account = Money.new(current_user.incomes
                                                     .where(active: true)
                                                     .unique
                                                     .where(amount_currency: @currency)
                                                     .sum(:amount_cents), @currency)

    # ==========================================
    # INGRESOS RECURRENTES REGISTRADOS (cobros reales del período)
    # ==========================================
    @recurring_incomes_paid = IncomeRecord.joins(:income)
                                          .where(income: { user_id: current_user.id })
                                          .where(received_date: @date_range)
                                          .where(actual_amount_currency: @currency)

    @total_recurring_income_paid = Money.new(@recurring_incomes_paid.sum(:actual_amount_cents), @currency)

    # ==========================================
    # INGRESOS ACTIVOS (recurrentes activos registrados en el período)
    # ==========================================
    @active_incomes = current_user.incomes
                                  .where(active: true, recurring: true)
                                  .where(amount_currency: @currency)

    @total_active_income = Money.new(
      @recurring_incomes_paid.sum(:actual_amount_cents),
      @currency
    )

    # Gastos que se pagaron usando estos ingresos activos
    expenses_from_active_cents =
      current_user.expenses.unique
        .where(spent_at: @date_range)
        .where(amount_currency: @currency)
        .where.not(income_source_id: nil)
        .where(income_source_id: @active_incomes.select(:id))
        .sum(:amount_cents) +
      ExpenseRecord.joins(:expense)
        .where(expense: { user_id: current_user.id })
        .where(paid_date: @date_range)
        .where(actual_amount_currency: @currency)
        .where.not(income_source_id: nil)
        .where(income_source_id: @active_incomes.select(:id))
        .sum(:actual_amount_cents)

    @total_active_income_net = @total_active_income - Money.new(expenses_from_active_cents, @currency)

    # ==========================================
    # SALDO INICIAL / CAPITAL EXISTENTE (ingresos inactivos / únicos)
    # ==========================================
    @capital_incomes = current_user.incomes
                                   .where(active: false)
                                   .where(amount_currency: @currency)

    @total_capital = Money.new(@capital_incomes.sum(:amount_cents), @currency)

    # ==========================================
    # PATRIMONIO TOTAL = Capital Inicial + Ingresos Recurrentes Registrados - Total Gastos
    # ==========================================
    @total_wealth = @total_capital + @total_active_income - @total_expenses

    # ==========================================
    # ORIGEN DE LOS GASTOS (por fuente de ingreso)
    # ==========================================
    expenses_from_income = current_user.expenses
                                       .where(spent_at: @date_range)
                                       .where(amount_currency: @currency)
                                       .joins(:income)
                                       .where("incomes.active = ?", true)
                                       .group("incomes.name")
                                       .sum(:amount_cents)
                                       .map { |name, cents| [name, cents.to_f / 100] }

    recurring_from_income = ExpenseRecord.joins(:expense)
                                         .where(expense: { user_id: current_user.id })
                                         .where(paid_date: @date_range)
                                         .where(actual_amount_currency: @currency)
                                         .joins(:income)
                                         .where("incomes.active = ?", true)
                                         .group("incomes.name")
                                         .sum(:actual_amount_cents)
                                         .map { |name, cents| [name, cents.to_f / 100] }

    all_sources = {}
    expenses_from_income.each { |name, amount| all_sources[name] = amount }
    recurring_from_income.each { |name, amount| all_sources[name] = (all_sources[name] || 0) + amount }

    @all_sources = all_sources

    # ==========================================
    # TRANSFERENCIAS entre fuentes
    # ==========================================
    transfers = current_user.source_transfers
                            .for_date_range(@date_range)
                            .by_currency(@currency)

    transfers_out = transfers.group(:from_source)
                             .sum(:amount_cents)
                             .transform_values { |cents| (cents.to_f / 100).round(2) }

    transfers_in = transfers.group(:to_source)
                            .sum(:amount_cents)
                            .transform_values { |cents| (cents.to_f / 100).round(2) }

    # ==========================================
    # GRÁFICO DE BARRAS: Ingresado vs Gastado por Origen (source)
    # ==========================================
    # Ingresado: montos recibidos agrupados por source
    received_by_source = IncomeRecord.joins(:income)
                                     .where(income: { user_id: current_user.id })
                                     .where(received_date: @date_range)
                                     .where(actual_amount_currency: @currency)
                                     .group("income.source")
                                     .sum(:actual_amount_cents)
                                     .transform_values { |cents| (cents.to_f / 100).round(2) }

    # Ingresado: ingresos únicos inactivos (capital) agrupados por source
    unique_income_by_source = current_user.incomes
                                          .where(active: false, recurring: false)
                                          .where(amount_currency: @currency)
                                          .group(:source)
                                          .sum(:amount_cents)
                                          .transform_values { |cents| (cents.to_f / 100).round(2) }

    # Combinar ambos en ingresado
    all_sources_income = received_by_source.merge(unique_income_by_source) { |_, a, b| a + b }

    # Gastado: gastos vinculados a ingresos, agrupados por source del ingreso
    expenses_by_source = Hash.new(0)
    current_user.expenses.unique
      .where(spent_at: @date_range)
      .where(amount_currency: @currency)
      .joins(:income)
      .group("income.source")
      .sum(:amount_cents)
      .each { |source, cents| expenses_by_source[source] += cents.to_f }

    ExpenseRecord.joins(:expense)
      .where(expense: { user_id: current_user.id })
      .where(paid_date: @date_range)
      .where(actual_amount_currency: @currency)
      .joins(:income)
      .group("income.source")
      .sum(:actual_amount_cents)
      .each { |source, cents| expenses_by_source[source] += cents.to_f }

    expenses_by_source.transform_values! { |v| (v / 100).round(2) }

    all_sources = (all_sources_income.keys + expenses_by_source.keys + transfers_in.keys + transfers_out.keys).uniq.sort

    chart_data = {}
    all_sources.each do |source|
      label = source.presence || "Otros"
      income_from_source = all_sources_income[source] || 0
      expense_from_source = expenses_by_source[source] || 0
      net_transfer = (transfers_in[source] || 0) - (transfers_out[source] || 0)
      chart_data[label] = [(income_from_source + net_transfer).round(2), expense_from_source]
    end

    @income_vs_expense_chart = [
      { name: "Ingresado", data: chart_data.transform_values { |v| v[0].round(2) } },
      { name: "Gastado", data: chart_data.transform_values { |v| v[1].round(2) } }
    ]

    # ==========================================
    # METAS DE AHORRO
    # ==========================================
    @goals = current_user.goals.in_progress.ordered

    # ==========================================
    # TASAS DE CAMBIO (EL TOQUE)
    # ==========================================
    @rate_period = params[:rate_period].presence || session[:rate_period].presence || "1M"
    session[:rate_period] = @rate_period

    @rate_date_from = case @rate_period
                      when "1W" then 1.week.ago.to_date
                      when "2W" then 2.weeks.ago.to_date
                      when "1M" then 1.month.ago.to_date
                      else 1.month.ago.to_date
                      end

    rate_date_to = Date.current
    @rate_date_from = rate_date_to if @rate_date_from > rate_date_to
    @rate_date_from = [@rate_date_from, rate_date_to - 6.days].min

    @exchange_rates = ExchangeRate.where(date: @rate_date_from..rate_date_to).ordered
    rates_by_date = @exchange_rates.index_by(&:date)
    date_range = (@rate_date_from..rate_date_to).to_a
    @exchange_rates_chart_data = date_range.reverse.map { |d|
      r = rates_by_date[d]
      { date: d.strftime("%Y-%m-%d"), usd: r&.usd_cup, eur: r&.eur_cup, cla: r&.cla_cup, zelle: r&.zelle_cup }
    }
    @exchange_rates_chart = [
      { name: "USD", data: @exchange_rates_chart_data.map { |r| [r[:date], r[:usd]] } },
      { name: "EUR", data: @exchange_rates_chart_data.map { |r| [r[:date], r[:eur]] } },
      { name: "CLA", data: @exchange_rates_chart_data.map { |r| [r[:date], r[:cla]] } },
      { name: "ZELLE", data: @exchange_rates_chart_data.map { |r| [r[:date], r[:zelle]] } }
    ].select { |s| s[:data].any? { |_d, v| v.present? } }

    all_values = @exchange_rates_chart.flat_map { |s| s[:data].map { |_d, v| v } }.compact
    min_val = all_values.min
    @chart_y_min = min_val ? ((min_val - 50) / 5.0).floor * 5 : 0

    # ==========================================
    # MONEDAS DISPONIBLES
    # ==========================================
    @available_currencies = (current_user.expenses.select(:amount_currency).distinct.pluck(:amount_currency) +
      current_user.incomes.select(:amount_currency).distinct.pluck(:amount_currency) +
      current_user.expense_records.select(:actual_amount_currency).distinct.pluck(:actual_amount_currency) +
      current_user.income_records.select(:actual_amount_currency).distinct.pluck(:actual_amount_currency)).uniq
    @available_currencies = ["CUP"] if @available_currencies.empty?
  end
end
