class CreateLeagueTies < ActiveRecord::Migration
  def change
    create_table :league_ties do |t|
      t.integer :team_id
      t.integer :league_id

      t.timestamps null: false
    end
  end
end
