class Question < ActiveRecord::Base

  has_many :question_answers

  def get_subtype_name(subtype_id)
    case subtype_id
    when 0
      return "Multiple Choice"
    when 1
      return "Yes/No"
    when 2
      return "Rating"
    when 3
      return "Text"
    else
      return "Invalid"
    end
  end
end
