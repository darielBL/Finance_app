class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:edit, :update, :destroy]
  before_action :load_categories, only: [:new, :create, :edit, :update]

  def index
    @expenses = current_user.expenses.ordered.page(params[:page]).per(5)
  end

  def new
    @expense = current_user.expenses.build(spent_at: Date.current)
  end

  def create
    # Remover amount_cents si está vacío (dejar que el concern lo maneje)
    if params[:expense][:amount_cents].blank?
      params[:expense].delete(:amount_cents)
    end

    @expense = current_user.expenses.build(expense_params)

    if @expense.save
      redirect_to expenses_path, notice: "Gasto creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Remover amount_cents si está vacío
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
    @income_sources = current_user.income_sources.where(active: true).order(:name)
  end

  def expense_params
    params.require(:expense).permit(:description, :amount_cents, :amount_currency, :spent_at, :category_id, :income_source_id, :normalized_amount)
  end
end