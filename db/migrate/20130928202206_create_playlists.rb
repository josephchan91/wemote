class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :tracks, array: true

      t.timestamps
    end
  end
end
