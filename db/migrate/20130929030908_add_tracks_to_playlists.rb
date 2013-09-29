class AddTracksToPlaylists < ActiveRecord::Migration
  def change
    change_table :playlists do |t|
      t.string :tracks, array: true
    end
  end
end
