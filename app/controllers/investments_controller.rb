class InvestmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_investment, only: [:edit, :update, :destroy]

  def index
    @investments = current_user.investments.ordered
    @total_by_currency = current_user.investments.group(:amount_currency).sum(:amount_cents)
  end

  def new
    @investment = current_user.investments.build(invested_at: Date.current)
  end

  def create
    @investment = current_user.investments.build(investment_params)

    if @investment.save
      redirect_to investments_path, notice: "Inversión creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @investment.update(investment_params)
      redirect_to investments_path, notice: "Inversión actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @investment.destroy
    redirect_to investments_path, notice: "Inversión eliminada exitosamente."
  end

  private

  def set_investment
    @investment = current_user.investments.find(params[:id])
  end

  def investment_params
    params.require(:investment).permit(:name, :amount_cents, :amount_currency, :invested_at, :normalized_amount)
  end
end