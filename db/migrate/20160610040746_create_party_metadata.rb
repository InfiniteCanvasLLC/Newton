class CreatePartyMetadata < ActiveRecord::Migration
  def change
    create_table :party_metadata do |t|
      t.references :party, index: true, foreign_key: true
      t.integer :data_type
      t.text :data

      t.timestamps null: false
    end
  end
end
