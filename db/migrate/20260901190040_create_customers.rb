class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :document_number
      t.string :phone
      t.string :email
      t.string :address

      t.timestamps
    end

    add_index :customers, [ :account_id, :document_number ], unique: true
  end
end