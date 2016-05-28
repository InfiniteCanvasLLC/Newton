class AddCurrentPartyIndexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_party_index, :integer
  end
end
