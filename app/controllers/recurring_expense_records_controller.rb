class RecurringExpenseRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:edit, :update]

  def new
    @recurring_expense = current_user.recurring_expenses.find(params[:recurring_expense_id])
    @record = @recurring_expense.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
    @income_sources = current_user.income_sources.where(active: true).order(:name)
  end

  def edit
    @income_sources = current_user.income_sources.where(active: true).order(:name)
  end

  def update
    if @record.update(record_params)
      redirect_to recurring_expenses_path, notice: "Pago registrado exitosamente."
    else
      @income_sources = current_user.income_sources.where(active: true).order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_record
    @record = current_user.recurring_expense_records.find(params[:id])
  end

  def record_params
    params.require(:recurring_expense_record).permit(:actual_amount_cents, :actual_amount_currency, :notes, :paid_date, :normalized_amount, :income_source_id)
  end
end