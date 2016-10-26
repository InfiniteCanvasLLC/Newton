class AddRelatedTopArtistsToFavoriteInfo < ActiveRecord::Migration
  def change
    add_column :favorite_infos, :related_top_artists, :text
  end
end
