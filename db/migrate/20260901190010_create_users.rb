class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :password_digest, null: false, default: ""
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :users, [ :account_id, :email ], unique: true
  end
end