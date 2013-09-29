class Playlist < ActiveRecord::Base
  validates :name, presence: true
  validates :tracks, presence: true,
    unless: Proc.new { |p| p.tracks != nil && p.tracks.empty? }
end