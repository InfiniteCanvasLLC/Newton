class AddTypeIdToLinkTos < ActiveRecord::Migration
  def change
    add_column :link_tos, :type_id, :integer, :default => 0
  end
end
