class CreatePartyConversations < ActiveRecord::Migration
  def change
    create_table :party_conversations do |t|
      t.references :party, index: true, foreign_key: true
      t.text :message
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
