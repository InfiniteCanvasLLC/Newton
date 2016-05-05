class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :answer_integer
      t.text :answer_text

      t.timestamps null: false
    end
  end
end
