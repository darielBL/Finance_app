class SourceTransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transfer, only: [:edit, :update, :destroy]
  before_action :load_form_data, only: [:new, :create, :edit, :update]

  def index
    @transfers = current_user.source_transfers.ordered.includes(:from_account, :to_account, :goal)
    @sources = current_user.incomes.distinct.pluck(:source).compact.sort
  end

  def new
    @transfer = current_user.source_transfers.build(transferred_at: Date.current)
  end

  def create
    @transfer = current_user.source_transfers.build(transfer_params)

    if @transfer.save
      create_goal_contribution(@transfer)
      redirect_to source_transfers_path, notice: "Transferencia creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @transfer.update(transfer_params)
      redirect_to source_transfers_path, notice: "Transferencia actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transfer.destroy
    redirect_to source_transfers_path, notice: "Transferencia eliminada exitosamente."
  end

  private

  def set_transfer
    @transfer = current_user.source_transfers.find(params[:id])
  end

  def load_form_data
    @accounts = current_user.financial_accounts.active.ordered
    @goals = current_user.goals.in_progress.ordered.includes(:target_account)
    @sources = current_user.incomes.distinct.pluck(:source).compact.sort
  end

  def transfer_params
    params.require(:source_transfer).permit(:from_source, :to_source, :from_account_id, :to_account_id, :goal_id, :amount_cents, :amount_currency, :transferred_at, :notes, :normalized_amount)
  end

  def create_goal_contribution(transfer)
    return unless transfer.goal_id.present?

    transfer.goal.contributions.create(
      amount_cents: transfer.amount_cents,
      amount_currency: transfer.amount_currency,
      contributed_at: transfer.transferred_at,
      from_source: transfer.display_from,
      notes: transfer.notes.present? ? "Transferencia: #{transfer.notes}" : nil
    )
  end
end
