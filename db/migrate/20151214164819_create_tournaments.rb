class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :start_time
      t.string :end_time
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
