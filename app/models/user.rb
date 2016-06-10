class User < ActiveRecord::Base

  has_and_belongs_to_many :parties, :uniq => true
  has_many :question_answers
  has_one :favorite_info
  before_create :build_default_favorites_info

  
  private def build_default_favorites_info
    # build default favorites_info instance. Will use default params.
    # The foreign key to the owning User model is set automatically
    build_favorite_info
    true # Always return true in callbacks as the normal 'continue' state
        # Assumes that the default_profile can **always** be created.
        # or
        # Check the validation of the profile. If it is not valid, then
        # return false from the callback. Best to use a before_validation 
        # if doing this. View code should check the errors of the child.
        # Or add the child's errors to the User model's error array of the :base
        # error item
  end


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
  
  def party_at_index(party_index)
    if party_index >= parties.count
      return nil;
    else
      return parties[party_index];
    end
  end

end
