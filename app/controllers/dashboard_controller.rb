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

    # Obtener gastos filtrados
    @expenses = current_user.expenses
                            .where(spent_at: @date_range)
                            .where(amount_currency: @currency)

    # Formato CORRECTO para Chartkick: [["Categoría", monto_en_centavos], ...]
    @chart_data = @expenses.joins(:category)
                           .group("categories.name")
                           .sum(:amount_cents)
                           .map { |category_name, cents| [category_name, cents.to_f / 100] }

    @total_expenses = Money.new(@expenses.sum(:amount_cents), @currency)

    @available_currencies = current_user.expenses
                                        .select(:amount_currency)
                                        .distinct
                                        .pluck(:amount_currency)
    @available_currencies = ["CUP"] if @available_currencies.empty?
  end
end