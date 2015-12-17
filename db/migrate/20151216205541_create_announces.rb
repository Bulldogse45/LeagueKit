class CreateAnnounces < ActiveRecord::Migration
  def change
    create_table :announces do |t|
      t.text :content
      t.belongs_to :announcable, polymorphic: true

      t.timestamps null: false
    end
    add_index :announces, [:announcable_id, :announcable_type]
  end
end
