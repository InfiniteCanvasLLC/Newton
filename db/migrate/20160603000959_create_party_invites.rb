class CreatePartyInvites < ActiveRecord::Migration
  def change
    create_table :party_invites do |t|
      t.integer :party_id
      t.integer :src_user_id
      t.integer :dst_user_id
      t.string :dst_user_name
      t.string :dst_user_email

      t.timestamps null: false
    end
  end
end
