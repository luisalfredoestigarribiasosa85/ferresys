class CreateSuppliers < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :ruc
      t.string :phone
      t.string :email
      t.string :address

      t.timestamps
    end

    add_index :suppliers, [ :account_id, :ruc ], unique: true
  end
end