class CreateFavoriteInfos < ActiveRecord::Migration
  def change
    create_table :favorite_infos do |t|
      t.text :top_artists
      t.text :top_songs
      t.text :top_genre
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
