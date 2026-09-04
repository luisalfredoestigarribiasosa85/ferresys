class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = current_account.products.order(:name)
    if params[:q].present?
      pattern = "%#{params[:q].strip.downcase}%"
      @products = @products.where("name ILIKE ? OR sku ILIKE ?", pattern, pattern)
    end
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.where(active: params[:active]) if params[:active].present?
    @products = @products.limit(100)
    @categories = current_account.categories.order(:name)
  end

  def show
    @movements = @product.stock_movements.recent.limit(20)
  end

  def new
    @product = current_account.products.build
  end

  def create
    @product = current_account.products.build(product_params)
    if @product.save
      redirect_to products_path, notice: "Producto creado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Producto actualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path, notice: "Producto eliminado"
    else
      redirect_to products_path, alert: @product.errors.full_messages.to_sentence
    end
  end

  private

  def set_product
    @product = current_account.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :category_id, :cost_price, :price,
                                    :stock, :min_stock, :unit, :active)
  end
end