class Playlist < ActiveRecord::Base
  validates :name, presence: true
  validates :tracks, presence: true,
    unless: Proc.new { |p| p.tracks != nil && p.tracks.empty? }

  def push(track_id)
    tracks_will_change!
    update_attributes tracks: tracks.push(track_id)
  end

  def pop
    tracks_will_change!
    next_track_id = tracks.shift
    update_attributes tracks: tracks
    next_track_id
  end

  def length
    tracks.length
  end
end