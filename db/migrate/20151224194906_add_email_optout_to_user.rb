class AddEmailOptoutToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_optout, :boolean
  end
end
