class FinancialAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:edit, :update, :destroy]

  def index
    @accounts = current_user.financial_accounts.active.ordered
  end

  def new
    @account = current_user.financial_accounts.build
  end

  def create
    @account = current_user.financial_accounts.build(account_params)

    if @account.save
      redirect_to financial_accounts_path, notice: "Cuenta creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to financial_accounts_path, notice: "Cuenta actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.archive
    redirect_to financial_accounts_path, notice: "Cuenta archivada exitosamente."
  end

  private

  def set_account
    @account = current_user.financial_accounts.find(params[:id])
  end

  def account_params
    params.require(:financial_account).permit(:name, :account_type, :color)
  end
end
