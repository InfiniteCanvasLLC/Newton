class CreateUserMetadata < ActiveRecord::Migration
  def change
    create_table :user_metadata do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :data_type
      t.text :data

      t.timestamps null: false
    end
  end
end
