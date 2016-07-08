class UserActionValidator < ActiveModel::Validator
  def validate(record)
    if record.is_question
      if !Question.exists?(id: record.action_id)
        record.errors.add(:base, "Question id " + record.action_id.to_s + " is not in the database.")
      end
    elsif record.is_linkto
      if !LinkTo.exists?(id: record.action_id)
        record.errors.add(:base, "LinkTo id " + record.action_id.to_s + " is not in the database.")
      end
    else
      record.errors.add(:base, "Unknown user action type.")
    end
  end
end
