class QuestionAnswerValidator < ActiveModel::Validator

  def validate(record)
    question_type = Question.find(record.question_id).question_type

    if (question_type == Question.multiple_choice) || (question_type == Question.yes_no)
      if (record.answer_integer.nil?)
        record.errors[:answer_integer] << "Answer must be non-nil"
      end
    elsif (question_type == Question.rating)
      if (record.answer_integer < 0) || (record.answer_integer > 10 )
        record.errors[:answer_integer] << "Answer must be between 0 and 10"
      end
    end
  end

end

class QuestionAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates_with QuestionAnswerValidator
  
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
