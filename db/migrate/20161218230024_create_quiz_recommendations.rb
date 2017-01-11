class CreateQuizRecommendations < ActiveRecord::Migration
  def change
    create_table :quiz_recommendations do |t|
      t.integer :question_one_answer
      t.integer :question_three_answer
      t.references :link_to, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
