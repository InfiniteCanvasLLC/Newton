class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :description
      t.integer :event_type
      t.datetime :start
      t.string :metadata

      t.timestamps null: false
    end
  end
end
