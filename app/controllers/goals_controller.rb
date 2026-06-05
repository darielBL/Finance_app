class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  def index
    @goals = current_user.goals.ordered
    @active_goals = @goals.in_progress
    @completed_goals = @goals.completed
  end

  def show
    @contributions = @goal.contributions.ordered
    @contribution = @goal.contributions.build(contributed_at: Date.current)
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

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:name, :target_amount_cents, :target_amount_currency, :deadline, :description, :source, :status, :normalized_amount)
  end
end
