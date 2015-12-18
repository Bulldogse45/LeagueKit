class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
