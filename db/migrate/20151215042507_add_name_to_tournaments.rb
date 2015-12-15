class AddNameToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :name, :string
  end
end
