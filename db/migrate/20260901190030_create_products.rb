class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :account, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.string :sku
      t.string :name, null: false, default: ""
      t.text :description
      t.decimal :cost_price, precision: 12, scale: 2, null: false, default: 0
      t.decimal :price, precision: 12, scale: 2, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.integer :min_stock, null: false, default: 0
      t.string :unit, null: false, default: "unidad"
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :products, [ :account_id, :sku ], unique: true
    add_index :products, [ :account_id, :name ]
  end
end