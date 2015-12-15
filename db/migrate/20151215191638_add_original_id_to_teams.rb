class AddOriginalIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :original_id, :integer
  end
end
