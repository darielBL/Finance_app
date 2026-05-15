class IncomeSourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income_source, only: [:edit, :update, :destroy]

  def index
    @income_sources = current_user.income_sources.order(created_at: :desc)
    @total_monthly = current_user.income_sources.active.sum do |income|
      income.estimated_monthly_amount.cents
    end
    @total_monthly = Money.new(@total_monthly, current_user.income_sources.first&.amount_currency || "CUP")
  end

  def new
    @income_source = current_user.income_sources.build
  end

  def create
    @income_source = current_user.income_sources.build(income_source_params)

    if @income_source.save
      redirect_to income_sources_path, notice: "Fuente de ingreso creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @income_source.update(income_source_params)
      redirect_to income_sources_path, notice: "Fuente de ingreso actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income_source.destroy
    redirect_to income_sources_path, notice: "Fuente de ingreso eliminada exitosamente."
  end

  private

  def set_income_source
    @income_source = current_user.income_sources.find(params[:id])
  end

  def income_source_params
    params.require(:income_source).permit(:name, :amount_cents, :amount_currency, :payment_method, :payment_method_detail, :frequency, :active)
  end
end