class AddTeamLogoToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :team_logo_id, :string
  end
end
