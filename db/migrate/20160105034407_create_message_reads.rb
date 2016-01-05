class CreateMessageReads < ActiveRecord::Migration
  def change
    create_table :message_reads do |t|
      t.integer :message_id
      t.integer :user_id
      t.boolean :read, default: :false

      t.timestamps null: false
    end
  end
end
