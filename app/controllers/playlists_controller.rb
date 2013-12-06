class PlaylistsController < ApplicationController

  def show
    @playlist = Playlist.find(params[:id])
    @tracks = Track.find_all_by_id(@playlist.tracks)
    past_playlist_ids_played = cookies[:past_playlist_ids_played].to_s.split(',')
    unless past_playlist_ids_played.include?(@playlist.id.to_s)
      cookies[:past_playlist_ids_played] = past_playlist_ids_played.push(@playlist.id).join(',')
    end
  end

  def new
    @playlist = Playlist.new
    @past_playlists_played = get_past_playlists_played
    @past_playlists_searched = get_past_playlists_searched
  end

  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.tracks = []

    @past_playlists_played = get_past_playlists_played
    @past_playlists_searched = get_past_playlists_searched

    if @playlist.save
      redirect_to playlist_path(@playlist)
    else
      render :new
    end
  end

  def update
    youtube_id = params[:youtube_id]
    playlist_id = params[:playlist_id]
    playlist = Playlist.find(playlist_id)

    if params[:commit] == "Add to Playlist" then
      track = Track.new(youtube_id: youtube_id, title: params[:track_title])
      track.save
      Pusher.trigger(playlist_id, 'track_added', {
        track_id: track.id,
        playlist_id: playlist_id
      })

      logger.debug "add to playlist"
      playlist.push_track(track)
      if playlist.length == 1
        Pusher.trigger(playlist_id, 'first_track_added', {})
      end
    elsif params[:commit] == "Play Now"
      track = Track.new(youtube_id: youtube_id, title: params[:track_title])
      track.save

      logger.debug "play now"
      playlist.unshift_track(track)
      Pusher.trigger(playlist_id, 'play_next_track_now', {})
    elsif params[:commit] == "Remove"
      track = Track.find(params[:track_id])

      logger.debug "remove"
      playlist.remove_track(track)
      Pusher.trigger(playlist_id, 'track_removed', {})
    end

    respond_to do |format|
      format.html { redirect_to playlist_path(playlist) }
      format.js
    end
  end

  def search
    @playlist = Playlist.find(params[:id])
    past_playlist_ids_searched = cookies[:past_playlist_ids_searched].to_s.split(',')
    unless past_playlist_ids_searched.include?(@playlist.id.to_s)
      cookies[:past_playlist_ids_searched] = past_playlist_ids_searched.push(@playlist.id).join(',')
    end
  end

  def next_track
    playlist_id = params[:id]
    playlist = Playlist.find(playlist_id)
    next_youtube_id = playlist.pop_track.youtube_id
    Pusher.trigger(playlist_id, 'track_removed', {})

    respond_to do |format|
      format.json {
        render json: {
          next_youtube_id: next_youtube_id
        }
      }
    end unless next_youtube_id.nil?
  end

  def track_list
    playlist_id = params[:id]
    @playlist = Playlist.find(playlist_id)
    @tracks = Track.find_all_by_id(@playlist.tracks)
    respond_to do |format|
      format.js
    end unless @tracks.nil?
  end

  private 

    def playlist_params
      params.require(:playlist).permit(:name)
    end

    def get_past_playlists_played
      past_playlist_ids_played = cookies[:past_playlist_ids_played].to_s.split(',')
      Playlist.find_all_by_id(past_playlist_ids_played) || []
    end

    def get_past_playlists_searched
      past_playlist_ids_searched = cookies[:past_playlist_ids_searched].to_s.split(',')
      Playlist.find_all_by_id(past_playlist_ids_searched) || []
    end
end