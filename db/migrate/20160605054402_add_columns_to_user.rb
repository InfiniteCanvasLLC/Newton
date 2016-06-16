class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :secondary_email, :string, :default => ""
    add_column :users, :gender, :integer, :default => 0
    add_column :users, :birthday, :date, :default => Time.now
    add_column :users, :zip_code, :integer, :default => 0
    add_column :users, :description, :text, :default => ""
  end
end
