class CreateLastSeenPartyConversations < ActiveRecord::Migration
  def change
    create_table :last_seen_party_conversations do |t|
      t.integer :user_id
      t.integer :party_id
      t.integer :party_conversation_id

      t.timestamps null: false
    end
  end
end
