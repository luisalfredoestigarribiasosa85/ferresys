class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, default: ""
      t.string :phone
      t.string :address
      t.integer :next_sale_number, null: false, default: 1

      t.timestamps
    end
  end
end