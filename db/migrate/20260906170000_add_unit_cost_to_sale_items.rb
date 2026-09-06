class AddUnitCostToSaleItems < ActiveRecord::Migration[8.1]
  def change
    add_column :sale_items, :unit_cost, :decimal, precision: 12, scale: 2, null: false, default: 0.0
  end
end