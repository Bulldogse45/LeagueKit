class AddPlayerPhotoToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :player_photo_id, :string
  end
end
