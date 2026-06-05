class DebtsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_debt, only: [:edit, :update, :destroy, :mark_as_paid]

  def index
    @debts = current_user.debts.ordered
    @debts_to_pay = @debts.to_pay.pending
    @debts_to_receive = @debts.to_receive.pending
    @debts_paid = @debts.paid

    @totals_to_pay = current_user.debts.to_pay.pending.group(:amount_currency).sum(:amount_cents)
    @totals_to_receive = current_user.debts.to_receive.pending.group(:amount_currency).sum(:amount_cents)
  end

  def new
    @debt = current_user.debts.build
  end

  def create
    @debt = current_user.debts.build(debt_params)

    if @debt.save
      redirect_to debts_path, notice: "Deuda creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @debt.update(debt_params)
      redirect_to debts_path, notice: "Deuda actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @debt.destroy
    redirect_to debts_path, notice: "Deuda eliminada exitosamente."
  end

  def mark_as_paid
    if @debt.paid?
      @debt.update(paid_at: nil)
      notice = "Deuda marcada como pendiente."
    else
      @debt.update(paid_at: Date.current)
      notice = "Deuda marcada como pagada."
    end

    redirect_to debts_path, notice: notice
  end

  private

  def set_debt
    @debt = current_user.debts.find(params[:id])
  end

  def debt_params
    params.require(:debt).permit(:name, :debt_type, :person_name, :amount_cents, :amount_currency, :due_date, :notes, :normalized_amount)
  end
end
