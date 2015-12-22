class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :begin_time
      t.integer :away_team_id
      t.integer :home_team_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
