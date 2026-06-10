class SourceTransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transfer, only: [:edit, :update, :destroy]
  before_action :load_sources, only: [:new, :create, :edit, :update]

  def index
    @transfers = current_user.source_transfers.ordered
    @sources = current_user.incomes.distinct.pluck(:source).compact.sort
  end

  def new
    @transfer = current_user.source_transfers.build(transferred_at: Date.current)
  end

  def create
    @transfer = current_user.source_transfers.build(transfer_params)

    if @transfer.save
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

  def transfer_params
    params.require(:source_transfer).permit(:from_source, :to_source, :amount_cents, :amount_currency, :transferred_at, :notes, :normalized_amount)
  end

  def load_sources
    @sources = current_user.incomes.distinct.pluck(:source).compact.sort
  end
end
