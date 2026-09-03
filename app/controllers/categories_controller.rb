class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = current_account.categories.order(:name)
  end

  def new
    @category = current_account.categories.build
  end

  def create
    @category = current_account.categories.build(category_params)
    if @category.save
      redirect_to categories_path, notice: "Categoría creada"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Categoría actualizada"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: "Categoría eliminada"
  end

  private

  def set_category
    @category = current_account.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end