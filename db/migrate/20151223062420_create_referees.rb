class CreateReferees < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :tournament_id

      t.timestamps null: false
    end
  end
end
