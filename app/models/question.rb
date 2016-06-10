class Question < ActiveRecord::Base

  has_many :question_answers

  def get_subtype_name()
    return type_id_to_string(self.question_type)
  end

  def metadata_one_formatted()
    if self.question_type == Question.yes_no
      return "Yes"
    else # Whatever Else
      return self.metadata_one
    end
  end

  def metadata_two_formatted()
    if self.question_type == Question.yes_no
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

  def self.get_type_name_to_id_array
    pairs = Array.new
    4.times do |i|
      pair = [LinkTo.type_id_to_string(i), i]
      pairs << pair
    end
    return pairs
  end

  def self.type_id_to_string(type_id)
    case type_id
    when Question.multiple_choice
      return "Multiple Choice"
    when Question.yes_no
      return "Yes/No"
    when Question.rating
      return "Rating"
    when Question.text
      return "Text"
    else
      return "Invalid"
    end
  end

  #IDs for specific types of question types
  def self.multiple_choice
    return 0
  end

  def self.yes_no
    return 1
  end

  def self.rating
    return 2
  end

  def self.text
    return 3
  end
end
