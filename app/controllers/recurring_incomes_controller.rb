class RecurringIncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recurring_income, only: [:edit, :update, :destroy, :show]

  def index
    @recurring_incomes = current_user.recurring_incomes.ordered
  end

  def show
    @records = @recurring_income.records.order(month: :desc)
  end

  def new
    @recurring_income = current_user.recurring_incomes.build
  end

  def create
    @recurring_income = current_user.recurring_incomes.build(recurring_income_params)

    # normalized_amount ya es manejado por el concern
    if @recurring_income.save
      @recurring_income.records.create(
        month: Date.current.beginning_of_month,
        actual_amount_currency: @recurring_income.estimated_amount_currency
      )
      redirect_to recurring_incomes_path, notice: "Ingreso recurrente creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recurring_income.update(recurring_income_params)
      redirect_to recurring_incomes_path, notice: "Ingreso recurrente actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @recurring_income.destroy
    redirect_to recurring_incomes_path, notice: "Ingreso recurrente eliminado."
  end

  private

  def set_recurring_income
    @recurring_income = current_user.recurring_incomes.find(params[:id])
  end

  def recurring_income_params
    params.require(:recurring_income).permit(:name, :estimated_amount_cents, :estimated_amount_currency, :due_date, :normalized_amount)
  end
end