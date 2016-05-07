class User < ActiveRecord::Base

  has_and_belongs_to_many :parties, :uniq => true
  
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

  def party_at_index(party_index)
    if parties.empty? == true
      return "<Default Party Name>"
    else
      return parties[party_index].name;
    end
  end

end
