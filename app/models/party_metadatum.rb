class PartyMetadatum < ActiveRecord::Base
  belongs_to :party

  # TYPE IDs
  def data_type_name
    return PartyMetadatum.type_id_to_type_name(self.data_type)
  end

  #############################################################################
  ### METADATA TYPES BEGIN
  #############################################################################
  # TYPE IDs
  def self.type_id_note
    return 0
  end

  # TYPE ID TO TYPE STRING
  def self.type_id_to_type_name(type_id)
    case type_id
      when PartyMetadatum.type_id_note
        return "Note"
      else
        return "UNKNOW"
    end
  end

  # TYPE STRING TO TYPE ID ARRAY
  def self.type_name_to_type_id_array
    pairs = Array.new
    1.times do |i|
      pair = [PartyMetadatum.type_id_to_type_name(i), i]
      pairs << pair
    end
    return pairs
  end
  #############################################################################
  ### METADATA TYPES END
  #############################################################################
end
