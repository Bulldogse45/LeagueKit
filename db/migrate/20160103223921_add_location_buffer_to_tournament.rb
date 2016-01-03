class AddLocationBufferToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :location_buffer, :integer
  end
end
