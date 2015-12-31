class AddTournamentLogoToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :tournament_logo_id, :string
  end
end
