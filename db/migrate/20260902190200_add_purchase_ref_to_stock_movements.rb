class AddPurchaseRefToStockMovements < ActiveRecord::Migration[8.1]
  def change
    add_reference :stock_movements, :purchase, null: true, foreign_key: true
  end
end
