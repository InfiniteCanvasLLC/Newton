class EnforceUserPartiesUniqueness < ActiveRecord::Migration
  def change
    add_index :parties_users, [ :user_id, :party_id ], :unique => true, :name => 'by_user_and_party'
  end
end
