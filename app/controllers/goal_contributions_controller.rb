class GoalContributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal
  before_action :set_contribution, only: [:edit, :update, :destroy]

  def new
    @contribution = @goal.contributions.build(contributed_at: Date.current)
  end

  def create
    @contribution = @goal.contributions.build(contribution_params)

    if @contribution.save
      redirect_to goal_path(@goal), notice: "Aporte registrado exitosamente."
    else
      @contributions = @goal.contributions.ordered
      render "goals/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contribution.update(contribution_params)
      redirect_to goal_path(@goal), notice: "Aporte actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contribution.destroy
    redirect_to goal_path(@goal), notice: "Aporte eliminado exitosamente."
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:goal_id])
  end

  def set_contribution
    @contribution = @goal.contributions.find(params[:id])
  end

  def contribution_params
    params.require(:goal_contribution).permit(:amount_cents, :amount_currency, :contributed_at, :notes, :source, :normalized_amount)
  end
end
