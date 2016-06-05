class User < ActiveRecord::Base

  has_and_belongs_to_many :parties, :uniq => true
  has_many :question_answers

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end

  def party_id
      ""
  end

  def question_answers
    QuestionAnswer.where("user_id = " + self.id.to_s)
  end

  def get_actions
    return UserAction.where("user_id = " + self.id.to_s)
  end

  def get_all_party_invites
    return PartyInvite.where(:dst_user_email => self.email) + PartyInvite.where(:dst_user_email => self.secondary_email)
  end

  def remove_party_invites(party_id)
    PartyInvite.where(:party_id => party_id, :dst_user_email => self.email).delete_all
    PartyInvite.where(:party_id => party_id, :dst_user_email => self.secondary_email).delete_all
  end

  def is_assigned_linkto( linkto )
    is_assigned = false;
    actions = self.get_actions
    actions.each do |action|
      if action.is_linkto == true #if the action is a linkto_id
        action_linkto = LinkTo.find(action.action_id)
        if action_linkto.id == linkto.id
          is_assigned = true
        end
      end
    end

    return is_assigned
  end

  def party_at_index(party_index)
    if party_index >= parties.count
      return nil;
    else
      return parties[party_index];
    end
  end

end
