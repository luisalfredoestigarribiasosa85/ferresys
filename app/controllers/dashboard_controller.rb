class DashboardController < ApplicationController
  def index
    today_start = Time.current.beginning_of_day
    month_start = Time.current.beginning_of_month
    @today_sales = current_account.sales.completed.where(created_at: today_start..)
    @daily_total = @today_sales.sum(:total)
    @sales_count = @today_sales.count

    @product_count = current_account.products.count
    @low_stock_count = current_account.products.low_stock.count
    @customer_count = current_account.customers.count
    @month_total = current_account.sales.completed.where(created_at: month_start..).sum(:total)

    @low_stock_products = current_account.products.low_stock.limit(8)
    @recent_sales = current_account.sales.includes(:customer).order(created_at: :desc).limit(8)

    @pending_credit = current_account.sales.completed.credit.sum(:total).to_d -
                      current_account.payments.sum(:amount).to_d

    @top_products = current_account.sales
      .joins(items: :product)
      .where(status: Sale.statuses[ :completed ], created_at: month_start..)
      .group("products.id", "products.name")
      .select("products.name", "SUM(sale_items.quantity) AS total_quantity")
      .order("SUM(sale_items.quantity) DESC")
      .limit(5)

    @seller_totals = current_account.sales.completed
      .where(created_at: month_start..)
      .joins(:user)
      .group("users.name")
      .sum(:total)
      .sort_by { |_, v| -v }
  end
end