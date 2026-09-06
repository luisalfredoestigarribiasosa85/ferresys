class PaymentsController < ApplicationController
  def index
    @payments = current_account.payments.order(created_at: :desc).includes(:customer, :sale, :user)
    @payments = @payments.where(customer_id: params[:customer_id]) if params[:customer_id].present?
    @payments = @payments.where(created_at: filter_dates) if params[:from].present? && params[:to].present?
    @payments = @payments.limit(200)
    @customers = current_account.customers.order(:name)
  end

  def new
    @payment = current_account.payments.build
    @customers = current_account.customers.order(:name)
    @open_sales = current_account.sales.completed.credit.includes(:customer).to_a

    if params[:customer_id].present? && current_account.customers.exists?(params[:customer_id])
      @payment.customer_id = params[:customer_id]
    end

    if params[:sale_id].present?
      sale = current_account.sales.completed.credit.includes(:customer).find_by(id: params[:sale_id])
      @payment.sale = sale if sale
    end
  end

  def create
    @payment = current_account.payments.build(payment_params)
    @payment.user = current_user

    if @payment.save
      redirect_to payments_path, notice: "Pago registrado"
    else
      @customers = current_account.customers.order(:name)
      @open_sales = current_account.sales.completed.credit.includes(:customer).to_a
      render :new, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:customer_id, :sale_id, :amount, :payment_method, :note)
  end

  def filter_dates
    from = Date.parse(params[:from]).beginning_of_day
    to = Date.parse(params[:to]).end_of_day
    from..to
  rescue ArgumentError, TypeError
    nil
  end
end