class AddLeagueLogoToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :league_logo_id, :string
  end
end
