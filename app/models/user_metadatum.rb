class UserMetadatum < ActiveRecord::Base
  belongs_to :user

  # TYPE IDs
  def data_type_name
    return UserMetadatum.type_id_to_type_name(self.data_type)
  end

  def is_note
    return self.data_type == UserMetadatum.type_id_note
  end

  def is_like
    return self.data_type == UserMetadatum.type_id_like
  end

  #############################################################################
  ### METADATA TYPES BEGIN
  #############################################################################
  # TYPE IDs
  def self.type_id_note
    return 0
  end

  def self.type_id_like
    # Choose a number far out because we don't want to include it as a metadata type that we can add via the dropdown
    return 1000
  end

  # TYPE ID TO TYPE STRING
  def self.type_id_to_type_name(type_id)
    case type_id
      when UserMetadatum.type_id_note
        return "Note"
      when UserMetadatum.type_id_like
        return "Like"
      else
        return "UNKNOW"
    end
  end

  # TYPE STRING TO TYPE ID ARRAY
  def self.type_name_to_type_id_array
    pairs = Array.new
    1.times do |i|
      pair = [UserMetadatum.type_id_to_type_name(i), i]
      pairs << pair
    end
    return pairs
  end
  #############################################################################
  ### METADATA TYPES END
  #############################################################################
end
