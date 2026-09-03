class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @customers = current_account.customers
    if params[:q].present?
      pattern = "%#{params[:q].strip.downcase}%"
      @customers = @customers.where("name ILIKE ? OR document_number ILIKE ?", pattern, pattern)
    end
    @customers = @customers.order(:name)
  end

  def show; end

  def new
    @customer = current_account.customers.build
  end

  def create
    @customer = current_account.customers.build(customer_params)
    if @customer.save
      redirect_to @customer, notice: "Cliente creado"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Cliente actualizado"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "Cliente eliminado"
  end

  private

  def set_customer
    @customer = current_account.customers.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :document_number, :phone, :email, :address)
  end
end