class AddIndexMessageIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :index_message_id, :integer
  end
end
