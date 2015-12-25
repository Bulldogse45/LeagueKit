class AddNotesToReferee < ActiveRecord::Migration
  def change
    add_column :referees, :notes, :text
  end
end
