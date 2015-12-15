class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token,   :null => false 
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone1
      t.string :phone2
      t.string :phone3
      t.string :phone4
      t.string :phone5

      t.timestamps null: false
    end
  end
end
