class PlaylistsController < ApplicationController

  def show
    @playlist = Playlist.find(params[:id])
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
    playlist = Playlist.find(params[:playlist_id])
    playlist.tracks += [@track_id]
    playlist.save
    respond_to do |format|
      format.html { redirect_to playlist_path(playlist) }
      format.js
    end
  end

  private 

    def playlist_params
      params.require(:playlist).permit(:name)
    end
end