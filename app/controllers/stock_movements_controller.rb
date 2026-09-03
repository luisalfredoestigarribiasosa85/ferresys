class StockMovementsController < ApplicationController
  before_action :set_products, only: %i[new create]

  def index
    scope = current_account.stock_movements.includes(:product, :user).recent
    scope = scope.where(product_id: params[:product_id]) if params[:product_id].present?
    scope = scope.where(movement_type: params[:movement_type]) if params[:movement_type].present?
    scope = scope.limit(200)
    @movements = scope
    @products = current_account.products.order(:name)
  end

  def new
    @movement = current_account.stock_movements.build
  end

  def create
    attributes = params.require(:stock_movement).permit(:product_id, :movement_type, :quantity, :note)
    movement_type = attributes[:movement_type]

    unless StockMovement.movement_types.key?(movement_type)
      flash.now[:alert] = "Tipo de movimiento inválido"
      render :new, status: :unprocessable_entity
      return
    end

    product = current_account.products.find(attributes[:product_id])

    @movement = current_account.stock_movements.build(
      product: product,
      movement_type: movement_type,
      quantity: signed_quantity(movement_type, attributes[:quantity]),
      note: attributes[:note]
    )

    new_stock = product.stock + @movement.quantity
    if new_stock.negative?
      flash.now[:alert] = "Stock insuficiente: solo hay #{product.stock} unidades disponibles"
      render :new, status: :unprocessable_entity
      return
    end

    previous_stock = product.stock

    StockMovement.transaction do
      product.update!(stock: new_stock)
      @movement.previous_quantity = previous_stock
      @movement.new_quantity = new_stock
      @movement.user = current_user
      @movement.save!
    end

    redirect_to stock_movements_path, notice: "Movimiento registrado"
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end

  private

  def set_products
    @products = current_account.products.active.order(:name)
  end

  def signed_quantity(type, raw_quantity)
    value = raw_quantity.to_i
    return value if value.zero? || type == "adjustment"

    %w[return purchase].include?(type) ? value.abs : -value.abs
  end
end