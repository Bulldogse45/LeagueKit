class CreatePlayerParticipants < ActiveRecord::Migration
  def change
    create_table :player_participants do |t|
      t.integer :player_id
      t.integer :team_id

      t.timestamps null: false
    end
  end
end
