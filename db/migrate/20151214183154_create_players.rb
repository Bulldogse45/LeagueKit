class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :date_of_birth
      t.string :shirt_size
      t.integer :jersey_number
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :suffix

      t.timestamps null: false
    end
  end
end
