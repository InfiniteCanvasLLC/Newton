class AddPermissionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :permissions, :integer, :default => 0
  end
end
