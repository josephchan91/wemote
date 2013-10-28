class PlaylistsController < ApplicationController

  def show
    @playlist = Playlist.find(params[:id])
    cookies[:current_playlist_id] = @playlist.id
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.tracks = []
    if @playlist.save
      redirect_to playlist_path(@playlist)
    else
      render :new
    end
  end

  def update
    @track_id = params[:track_id]
    playlist_id = params[:playlist_id]
    playlist = Playlist.find(playlist_id)
    unless params[:play_now] then
      playlist.push_track(@track_id)
      if playlist.length == 1
        Pusher.trigger(playlist_id, 'track_added', {})
      end
    else
      playlist.unshift_track(@track_id)
      Pusher.trigger(playlist_id, 'play_next_track_now', {})
    end
    respond_to do |format|
      format.html { redirect_to playlist_path(playlist) }
      format.js
    end
  end

  def search
    @playlist = Playlist.find(params[:id])
  end

  def next_track
    playlist = Playlist.find(params[:id])
    next_track_id = playlist.pop_track
    respond_to do |format|
      format.json { render json: {
        next_track_id: next_track_id
      } }
    end unless next_track_id.nil?
  end

  private 

    def playlist_params
      params.require(:playlist).permit(:name)
    end
end