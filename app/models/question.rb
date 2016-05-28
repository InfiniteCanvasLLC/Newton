class Question < ActiveRecord::Base

  has_many :question_answers

  def get_subtype_name()
    case self.question_type
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
  
  def metadata_one_formatted()
    if self.question_type == 1 # Yes/No
      return "Yes"
    else # Whatever Else
      return self.metadata_one
    end
  end
  
  def metadata_two_formatted()
    if self.question_type == 1 # Yes/No
      return "No"
    else # Whatever Else
      return self.metadata_two
    end
  end
  
  def metadata_three_formatted()
    return self.metadata_three
  end
  
  def metadata_four_formatted()
    return self.metadata_four
  end
end
