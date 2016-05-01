class CreateJoinTableUserParty < ActiveRecord::Migration
  def change
    create_join_table :users, :parties do |t|
      # t.index [:user_id, :party_id]
      # t.index [:party_id, :user_id]
    end
  end
end
