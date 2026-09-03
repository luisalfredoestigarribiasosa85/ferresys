class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[edit update destroy]

  def index
    @suppliers = current_account.suppliers
    if params[:q].present?
      pattern = "%#{params[:q].strip.downcase}%"
      @suppliers = @suppliers.where("name ILIKE ? OR ruc ILIKE ?", pattern, pattern)
    end
    @suppliers = @suppliers.order(:name)
  end

  def new
    @supplier = current_account.suppliers.build
  end

  def create
    @supplier = current_account.suppliers.build(supplier_params)
    if @supplier.save
      redirect_to suppliers_path, notice: "Proveedor creado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: "Proveedor actualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @supplier.destroy
    redirect_to suppliers_path, notice: "Proveedor eliminado"
  end

  private

  def set_supplier
    @supplier = current_account.suppliers.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :ruc, :phone, :email, :address)
  end
end