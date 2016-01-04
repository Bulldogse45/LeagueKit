class AddTeamBufferToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :team_buffer, :integer
  end
end
