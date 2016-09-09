class AddAdministratorToParty < ActiveRecord::Migration
  def change
    add_reference :parties, :administrator, references: :users, index: true
    add_foreign_key :parties, :users, column: :administrator_id
  end
end
