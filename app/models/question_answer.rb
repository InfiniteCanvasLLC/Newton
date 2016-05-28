class QuestionAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  def get_answer()
    question = Question.find(self.question_id)
    if self.answer_text.nil? || self.answer_text.empty?
      case self.answer_integer
      when 0
        return question.metadata_one_formatted()
      when 1
        return question.metadata_two_formatted()
      when 2
        return question.metadata_three_formatted()
      when 3
        return question.metadata_four_formatted()
      else
        return self.answer_integer
      end
    else
      return self.answer_text
    end
  end
end
