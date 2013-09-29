require 'google/api_client'

class SearchesController < ApplicationController
  def index
    @playlist = Playlist.find(params[:playlist_id])
    if params[:search].present?
      @query = params[:search]

      client = Google::APIClient.new(
        key: 'AIzaSyCzWkXtAFP97Vlevf1TVV_tXzD_CfZtt1g',
        authorization: nil
      )
      youtube = client.discovered_api('youtube', 'v3')
      @results = client.execute!(
        api_method: youtube.search.list,
        parameters: {
          part: 'id,snippet',
          q: @query,
          maxResults: 10,
          type: 'video'
        }
      )
    else
      render "playlists/show"
    end
  end
end