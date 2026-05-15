class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.for_user(current_user).active.order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to categories_path, notice: "Categoría creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Categoría actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Verificar si es categoría base
    if @category.user_id.nil?
      redirect_to categories_path, alert: "No se puede eliminar una categoría base."
    elsif defined?(Expense) && @category.expenses.exists?
      redirect_to categories_path, alert: "No se puede eliminar la categoría porque tiene gastos asociados."
    else
      @category.soft_delete
      redirect_to categories_path, notice: "Categoría eliminada exitosamente."
    end
  end


  private

  def set_category
    # Permitir encontrar categorías que sean del usuario O categorías base
    @category = Category.where(user_id: [current_user.id, nil]).find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end