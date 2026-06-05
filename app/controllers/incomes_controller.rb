class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: [:edit, :update, :destroy]

  def index
    @incomes = current_user.incomes.order(Arel.sql("recurring DESC, due_day, name"))
    @recurring_incomes = current_user.incomes.recurring.ordered

    @total_monthly = current_user.incomes.unique.active.sum do |income|
      income.amount_cents
    end
    total_currency = current_user.incomes.unique.first&.amount_currency || "CUP"
    @total_monthly = Money.new(@total_monthly, total_currency)
  end

  def new
    @income = current_user.incomes.build(recurring: params[:recurring] == "true")
  end

  def create
    if params[:income][:amount_cents].blank?
      params[:income].delete(:amount_cents)
    end

    @income = current_user.incomes.build(income_params)
    if @income.recurring?
      @income.active = true if @income.active.nil?
    else
      @income.active = false
    end

    if @income.save
      if @income.recurring?
        @income.records.create(
          month: Date.current.beginning_of_month,
          actual_amount_currency: @income.amount_currency
        )
      end
      redirect_to incomes_path, notice: "Ingreso creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:income][:amount_cents].blank?
      params[:income].delete(:amount_cents)
    end

    if @income.update(income_params)
      redirect_to incomes_path, notice: "Ingreso actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income.destroy
    redirect_to incomes_path, notice: "Ingreso eliminado exitosamente."
  end

  private

  def set_income
    @income = current_user.incomes.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:name, :amount_cents, :amount_currency, :source, :due_day, :recurring, :active, :normalized_amount)
  end
end
