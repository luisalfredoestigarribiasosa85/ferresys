class CreateStockMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_movements do |t|
      t.references :account, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :sale, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :movement_type, null: false, default: 0
      t.integer :quantity, null: false, default: 0
      t.integer :previous_quantity, null: false, default: 0
      t.integer :new_quantity, null: false, default: 0
      t.text :note

      t.timestamps
    end

    add_index :stock_movements, [ :account_id, :product_id, :created_at ]
    add_index :stock_movements, [ :account_id, :movement_type ]
  end
end