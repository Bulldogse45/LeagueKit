class CreateAnnouncementVieweds < ActiveRecord::Migration
  def change
    create_table :announcement_vieweds do |t|
      t.integer :announce_id
      t.integer :user_id
      t.boolean :viewed, default: :false

      t.timestamps null: false
    end
  end
end
