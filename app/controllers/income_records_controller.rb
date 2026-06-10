class IncomeRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:edit, :update]

  def new
    @income = current_user.incomes.find(params[:income_id])
    @record = @income.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
  end

  def create
    @income = current_user.incomes.find(params[:income_id])
    @record = @income.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)

    if params[:income_record][:normalized_amount].present?
      params[:income_record][:actual_amount_cents] = (params[:income_record][:normalized_amount].to_f * 100).to_i
    end

    if @record.update(record_params)
      redirect_to incomes_path, notice: "Ingreso registrado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @income = @record.income
  end

  def update
    if params[:income_record][:normalized_amount].present?
      params[:income_record][:actual_amount_cents] = (params[:income_record][:normalized_amount].to_f * 100).to_i
    end

    if @record.update(record_params)
      redirect_to incomes_path, notice: "Ingreso registrado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_record
    @record = current_user.income_records.find(params[:id])
  end

  def record_params
    params.require(:income_record).permit(:actual_amount_cents, :actual_amount_currency, :notes, :received_date, :normalized_amount)
  end
end
