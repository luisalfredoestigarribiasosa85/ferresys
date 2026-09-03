class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :account, null: false, foreign_key: true
      t.references :customer, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :number, null: false
      t.integer :status, null: false, default: 0
      t.integer :payment_method, null: false, default: 0
      t.decimal :subtotal, precision: 12, scale: 2, null: false, default: 0
      t.decimal :discount, precision: 12, scale: 2, null: false, default: 0
      t.decimal :total, precision: 12, scale: 2, null: false, default: 0
      t.text :note

      t.timestamps
    end

    add_index :sales, [ :account_id, :number ], unique: true
    add_index :sales, [ :account_id, :created_at ]
  end
end