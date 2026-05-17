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

    # GRÁFICO 1: Distribución de ingresos por tipo de cuenta
    @income_by_account = current_user.income_sources
                                     .where(active: true)
                                     .where(amount_currency: @currency)
                                     .group(:payment_method, :payment_method_detail)
                                     .sum(:amount_cents)
                                     .map { |(method, detail), cents|
                                       # Limpiar etiqueta: si method y detail son iguales o repetitivos
                                       label = if detail.present? && detail.downcase == method.to_s.downcase
                                                 method.to_s.capitalize
                                               elsif detail.present?
                                                 "#{method} - #{detail}"
                                               elsif method.present?
                                                 method.to_s.capitalize
                                               else
                                                 "Otros"
                                               end
                                       [label, cents.to_f / 100]
                                     }

    @total_income_by_account = Money.new(current_user.income_sources
                                                     .where(active: true)
                                                     .where(amount_currency: @currency)
                                                     .sum(:amount_cents), @currency)

    # GRÁFICO 2: Gastos por categoría
    @expenses = current_user.expenses.where(spent_at: @date_range, amount_currency: @currency)
    @expenses_by_category = @expenses.joins(:category)
                                     .group("categories.name")
                                     .sum(:amount_cents)
                                     .map { |category_name, cents| [category_name, cents.to_f / 100] }

    @total_expenses = Money.new(@expenses.sum(:amount_cents), @currency)

    # INGRESOS ACTIVOS (para reportes mensuales)
    @active_income_sources = current_user.income_sources
                                         .where(active: true)
                                         .where(amount_currency: @currency)

    @total_active_income = Money.new(@active_income_sources.sum(:amount_cents), @currency)

    # SALDO INICIAL / CAPITAL EXISTENTE (ingresos inactivos o marcados como "capital")
    @capital_income_sources = current_user.income_sources
                                          .where(active: false)
                                          .where(amount_currency: @currency)

    @total_capital = Money.new(@capital_income_sources.sum(:amount_cents), @currency)

    # PATRIMONIO TOTAL = Capital Inicial + Ingresos Activos
    @total_wealth = @total_capital + @total_active_income

    # Para el gráfico de ingresos por cuenta, mostrar SOLO activos (no capital)
    @income_by_account = current_user.income_sources
                                     .where(active: true)
                                     .where(amount_currency: @currency)
                                     .group(:payment_method, :payment_method_detail)
                                     .sum(:amount_cents)
                                     .map { |(method, detail), cents|
                                       label = detail.present? ? "#{method} - #{detail}" : (method.present? ? method : "Otros")
                                       [label, cents.to_f / 100]
                                     }

    # Monedas disponibles
    @available_currencies = (current_user.expenses.select(:amount_currency).distinct.pluck(:amount_currency) +
      current_user.income_sources.select(:amount_currency).distinct.pluck(:amount_currency)).uniq
    @available_currencies = ["CUP"] if @available_currencies.empty?
  end
end