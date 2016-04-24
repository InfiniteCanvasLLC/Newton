class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :action_type
      t.integer :action_id

      t.timestamps null: false
    end
  end
end
