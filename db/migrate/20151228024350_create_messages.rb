class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :to_user_id
      t.integer :from_user_id
      t.text :subject
      t.text :content
      t.integer :message_status_id

      t.timestamps null: false
    end
  end
end
