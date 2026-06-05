class ExpenseRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:edit, :update]

  def new
    @expense = current_user.expenses.find(params[:expense_id])
    @record = @expense.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
    @incomes = current_user.incomes.order(:name)
  end

  def create
    @expense = current_user.expenses.find(params[:expense_id])
    @record = @expense.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
    @incomes = current_user.incomes.order(:name)

    if params[:expense_record][:normalized_amount].present?
      params[:expense_record][:actual_amount_cents] = (params[:expense_record][:normalized_amount].to_f * 100).to_i
    end

    if @record.update(record_params)
      redirect_to expenses_path, notice: "Pago registrado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @incomes = current_user.incomes.order(:name)
  end

  def update
    if params[:expense_record][:normalized_amount].present?
      params[:expense_record][:actual_amount_cents] = (params[:expense_record][:normalized_amount].to_f * 100).to_i
    end

    if @record.update(record_params)
      redirect_to expenses_path, notice: "Pago registrado exitosamente."
    else
      @incomes = current_user.incomes.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_record
    @record = current_user.expense_records.find(params[:id])
  end

  def record_params
    params.require(:expense_record).permit(:actual_amount_cents, :actual_amount_currency, :notes, :paid_date, :normalized_amount, :income_source_id)
  end
end
