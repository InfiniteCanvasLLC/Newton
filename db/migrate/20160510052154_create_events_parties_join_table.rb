class CreateEventsPartiesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :events, :parties do |t|
      # t.index [:event_id, :party_id]
      # t.index [:party_id, :event_id]
    end
  end
end
