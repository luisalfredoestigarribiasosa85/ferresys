class DashboardController < ApplicationController
  def index
    today_start = Time.current.beginning_of_day
    @today_sales = current_account.sales.completed.where(created_at: today_start..)
    @daily_total = @today_sales.sum(:total)
    @sales_count = @today_sales.count

    @product_count = current_account.products.count
    @low_stock_count = current_account.products.low_stock.count
    @customer_count = current_account.customers.count
    @month_total = current_account.sales.completed.where(created_at: Time.current.beginning_of_month..).sum(:total)

    @low_stock_products = current_account.products.low_stock.limit(8)
    @recent_sales = current_account.sales.includes(:customer).order(created_at: :desc).limit(8)
  end
end