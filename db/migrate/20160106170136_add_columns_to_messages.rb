class AddColumnsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :team_id, :integer
    add_column :messages, :player_id, :integer
    add_column :messages, :team_request, :boolean, default: :false 
  end
end
