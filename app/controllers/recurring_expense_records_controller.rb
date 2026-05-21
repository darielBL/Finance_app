class RecurringExpenseRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:edit, :update]

  def new
    @recurring_expense = current_user.recurring_expenses.find(params[:recurring_expense_id])
    @record = @recurring_expense.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
    @income_sources = current_user.income_sources.where(active: true).order(:name)
  end

  def create
    @recurring_expense = current_user.recurring_expenses.find(params[:recurring_expense_id])
    @record = @recurring_expense.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
    @income_sources = current_user.income_sources.where(active: true).order(:name)

    # Convertir normalized_amount a cents si viene
    if params[:recurring_expense_record][:normalized_amount].present?
      params[:recurring_expense_record][:actual_amount_cents] = (params[:recurring_expense_record][:normalized_amount].to_f * 100).to_i
    end

    if @record.update(record_params)
      redirect_to recurring_expenses_path, notice: "Pago registrado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @income_sources = current_user.income_sources.where(active: true).order(:name)
  end

  def update
    # Convertir normalized_amount a cents si viene
    if params[:recurring_expense_record][:normalized_amount].present?
      params[:recurring_expense_record][:actual_amount_cents] = (params[:recurring_expense_record][:normalized_amount].to_f * 100).to_i
    end

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