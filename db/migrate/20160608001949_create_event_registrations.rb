class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.references :party, index: true, foreign_key: true
      t.integer :user_id
      t.integer :event_id
      t.integer :commitment

      t.timestamps null: false
    end
  end
end
