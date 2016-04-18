class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.integer :question_type
      t.string :metadata_one
      t.string :metadata_two
      t.string :metadata_three
      t.string :metadata_four

      t.timestamps null: false
    end
  end
end
