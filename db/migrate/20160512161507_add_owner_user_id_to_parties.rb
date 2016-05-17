class AddOwnerUserIdToParties < ActiveRecord::Migration
  def change
    add_column :parties, :owner_user_id, :integer
  end
end
