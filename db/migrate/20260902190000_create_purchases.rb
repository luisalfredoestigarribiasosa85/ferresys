class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.references :account, null: false, foreign_key: true
      t.references :supplier, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :number, null: false
      t.decimal :subtotal, precision: 12, scale: 2, null: false, default: 0
      t.decimal :total, precision: 12, scale: 2, null: false, default: 0
      t.text :note

      t.timestamps
    end

    add_index :purchases, [ :account_id, :number ], unique: true
    add_index :purchases, [ :account_id, :created_at ]
  end
end
