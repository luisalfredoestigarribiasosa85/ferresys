class ReportsController < ApplicationController
  def daily_cash
    @date = (Date.parse(params[:date]) rescue Date.current)
    @date = Date.current if @date > Date.current

    day_start = @date.beginning_of_day
    day_end = @date.end_of_day
    @sales = current_account.sales.completed.where(created_at: day_start..day_end)

    @total = @sales.sum(:total)

    @by_payment = {}
    Sale.payment_methods.each_key do |method|
      @by_payment[method] = @sales.where(payment_method: method).sum(:total)
    end

    @discount_total = @sales.sum(:discount).to_d
    @sale_count = @sales.count
    @customer_count = @sales.where.not(customer_id: nil).distinct.count(:customer_id)
  end
end
