class CreatePurchaseItems < ActiveRecord::Migration[8.1]
  def change
    create_table :purchase_items do |t|
      t.references :purchase, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_cost, precision: 12, scale: 2, null: false, default: 0
      t.decimal :subtotal, precision: 12, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
