class RecurringIncomeRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:edit, :update]

  def new
    @recurring_income = current_user.recurring_incomes.find(params[:recurring_income_id])
    @record = @recurring_income.records.find_or_initialize_by(month: params[:month] || Date.current.beginning_of_month)
  end

  def edit
  end

  def update
    # Convertir normalized_amount a cents
    if params[:recurring_income_record][:normalized_amount].present?
      @record.actual_amount_cents = (params[:recurring_income_record][:normalized_amount].to_f * 100).to_i
    end

    if @record.update(record_params.except(:normalized_amount))
      redirect_to recurring_incomes_path, notice: "Ingreso registrado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
    en

  private

  def set_record
    @record = current_user.recurring_income_records.find(params[:id])
  end

    def record_params
      params.require(:recurring_income_record).permit(:actual_amount_cents, :actual_amount_currency, :notes, :received_date, :normalized_amount)
    end
  end
end
