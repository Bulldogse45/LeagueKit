class AddRefBufferToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :ref_buffer, :integer
  end
end
