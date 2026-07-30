class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: [:show, :edit, :update, :destroy, :postpone]
  before_action :load_accounts, only: [:new, :create, :edit, :update]

  def index
    @goals = current_user.goals.ordered
    @active_goals = @goals.in_progress
    @completed_goals = @goals.completed
  end

  def show
    @contributions = @goal.contributions.ordered
  end

  def new
    @goal = current_user.goals.build
  end

  def create
    @goal = current_user.goals.build(goal_params)

    if @goal.save
      redirect_to goals_path, notice: "Meta creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @contributions = @goal.contributions.ordered
  end

  def update
    if @goal.update(goal_params)
      redirect_to goals_path, notice: "Meta actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Meta eliminada exitosamente."
  end

  def postpone
    if @goal.deadline
      @goal.update(deadline: @goal.deadline + 30.days)
      redirect_to goal_path(@goal), notice: "Fecha límite pospuesta 30 días. Nuevo límite: #{l(@goal.deadline, format: :long)}."
    else
      redirect_to goal_path(@goal), alert: "Esta meta no tiene fecha límite definida."
    end
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def load_accounts
    @accounts = current_user.financial_accounts.active.ordered
  end

  def goal_params
    params.require(:goal).permit(:name, :target_amount_cents, :target_amount_currency, :deadline, :description, :target_account_id, :status, :icon, :normalized_amount)
  end
end
