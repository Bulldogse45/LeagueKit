class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :tournament_id
      t.integer :season_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
