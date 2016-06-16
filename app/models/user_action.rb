class UserAction < ActiveRecord::Base
  belongs_to :user

  def self.get_type_name_to_id_array
    pairs = Array.new
    2.times do |i|
      pair = [UserAction.type_id_to_string(i), i]
      pairs << pair
    end
    return pairs
  end

  def self.type_id_to_string(type_id)
    case type_id
    when UserAction.question_type
      return "Question"
    when UserAction.linkto_type
      return "LinkTo"
    else
      return "Invalid"
    end
  end

  def is_question
    return self.action_type == UserAction.question_type
  end

  def is_linkto
    return self.action_type == UserAction.linkto_type
  end

  def self.question_type
    return 0
  end

  def self.linkto_type
    return 1
  end

end
