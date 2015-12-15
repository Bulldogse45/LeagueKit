class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :begin_time
      t.integer :participant1_id
      t.integer :participant2_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
