class CreateJoinPartyRequests < ActiveRecord::Migration
  def change
    create_table :join_party_requests do |t|
      t.integer :party_id
      t.integer :user_id
      t.text :message

      t.timestamps null: false
    end
  end
end
