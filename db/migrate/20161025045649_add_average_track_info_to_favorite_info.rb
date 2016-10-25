class AddAverageTrackInfoToFavoriteInfo < ActiveRecord::Migration
  def change
    add_column :favorite_infos, :average_track_info, :text
  end
end
