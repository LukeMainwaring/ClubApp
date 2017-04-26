class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.string :email
      t.string :password_hash
      t.string :phone
      t.string :position

      t.timestamps null: false
    end
  end
end
