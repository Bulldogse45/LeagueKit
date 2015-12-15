class CreateTeamParticipants < ActiveRecord::Migration
  def change
    create_table :team_participants do |t|
      t.integer :team_id
      t.integer :tournament_id

      t.timestamps null: false
    end
  end
end
