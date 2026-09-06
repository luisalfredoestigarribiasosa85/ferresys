class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :account, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :sale, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false, default: 0.0
      t.integer :payment_method, null: false, default: 0
      t.text :note
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end