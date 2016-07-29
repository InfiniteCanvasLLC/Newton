class FavoriteInfo < ActiveRecord::Base
  belongs_to :user

  def top_artists_to_genres
    hash = Hash.new
    if !top_artists.nil?
      parsed = JSON.parse(top_artists)
      parsed.count.times do |i|
        hash[parsed[i.to_s]["name"]] = parsed[i.to_s]["genres"]
      end
    end
    return hash
  end

  def top_songs_to_artists
    hash = Hash.new
    if !top_artists.nil?
      parsed = JSON.parse(top_songs)
      parsed.count.times do |i|
        hash[parsed[i.to_s]["name"]] = parsed[i.to_s]["artist"]
      end
    end
    return hash
  end
end
