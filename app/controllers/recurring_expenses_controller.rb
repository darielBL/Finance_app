class RecurringExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recurring_expense, only: [:edit, :update, :destroy, :show]

  def index
    @recurring_expenses = current_user.recurring_expenses.ordered
  end

  def show
    @records = @recurring_expense.records.order(month: :desc)
  end

  def new
    @recurring_expense = current_user.recurring_expenses.build
  end

  def create
    @recurring_expense = current_user.recurring_expenses.build(recurring_expense_params)

    if @recurring_expense.save
      @recurring_expense.records.create(
        month: Date.current.beginning_of_month,
        actual_amount_currency: @recurring_expense.estimated_amount_currency
      )
      redirect_to recurring_expenses_path, notice: "Gasto recurrente creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recurring_expense.update(recurring_expense_params)
      redirect_to recurring_expenses_path, notice: "Gasto recurrente actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recurring_expense.destroy
    redirect_to recurring_expenses_path, notice: "Gasto recurrente eliminado."
  end

  private

  def set_recurring_expense
    @recurring_expense = current_user.recurring_expenses.find(params[:id])
  end

  def recurring_expense_params
    params.require(:recurring_expense).permit(:name, :estimated_amount_cents, :estimated_amount_currency, :due_day, :normalized_amount)
  end
end