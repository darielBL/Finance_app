class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:edit, :update, :destroy]
  before_action :load_categories, only: [:new, :create, :edit, :update]

  def index
    @expenses = current_user.expenses.order(Arel.sql("recurring DESC, due_day, name, spent_at DESC"))
  end

  def new
    @expense = current_user.expenses.build(spent_at: Date.current, recurring: params[:recurring] == "true")
  end

  def create
    if params[:expense][:amount_cents].blank?
      params[:expense].delete(:amount_cents)
    end

    @expense = current_user.expenses.build(expense_params)

    if @expense.save
      if @expense.recurring?
        @expense.records.create(
          month: Date.current.beginning_of_month,
          actual_amount_currency: @expense.amount_currency
        )
      end
      redirect_to expenses_path, notice: "Gasto creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:expense][:amount_cents].blank?
      params[:expense].delete(:amount_cents)
    end

    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Gasto actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Gasto eliminado exitosamente."
  end

  private

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end

  def load_categories
    @categories = Category.for_user(current_user).active.order(:name)
    @incomes = current_user.incomes.order(:name)
  end

  def expense_params
    params.require(:expense).permit(:name, :description, :amount_cents, :amount_currency, :spent_at, :category_id, :due_day, :recurring, :income_source_id, :normalized_amount)
  end
end
