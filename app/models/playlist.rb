class Playlist < ActiveRecord::Base
  validates :name, presence: true
  validates :tracks, presence: true,
    unless: Proc.new { |p| p.tracks != nil && p.tracks.empty? }

  scope :non_empty, -> { where("tracks <> ''") }

  def push_track(track)
    tracks_will_change!
    update_attributes tracks: tracks.push(track.id)
  end

  def unshift_track(track)
    tracks_will_change!
    update_attributes tracks: tracks.unshift(track.id)
  end

  def pop_track
    tracks_will_change!
    logger.debug "before popping: "+tracks.to_s
    next_track_id = tracks.shift
    update_attributes tracks: tracks

    next_track = Track.find(next_track_id)
  end

  def remove_track(track)
    if track.nil? then
      return
    else
      tracks_will_change!
      logger.debug "before removing track: "+tracks.to_s
      tracks.delete(track.id.to_s)
      update_attributes tracks: tracks
      track.delete
      logger.debug "after removing tracks: "+tracks.to_s
    end
  end

  def length
    tracks.length
  end
end