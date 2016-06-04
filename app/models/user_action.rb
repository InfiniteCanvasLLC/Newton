class UserAction < ActiveRecord::Base
  belongs_to :user

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
