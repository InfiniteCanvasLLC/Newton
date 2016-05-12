class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.integer :sentiment
      t.integer :issue_type
      t.string :email
      t.string :description

      t.timestamps null: false
    end
  end
end
