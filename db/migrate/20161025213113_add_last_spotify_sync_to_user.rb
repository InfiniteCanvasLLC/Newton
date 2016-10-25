class AddLastSpotifySyncToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_spotify_sync, :datetime
  end
end
