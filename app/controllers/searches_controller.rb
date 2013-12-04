require 'google/api_client'

class SearchesController < ApplicationController
  def index
    @playlist = Playlist.find(params[:playlist_id])
    if params[:search].present?
      @query = params[:search]

      client = Google::APIClient.new(
        key: ENV["GOOGLE_API_KEY"],
        authorization: nil
      )
      youtube = client.discovered_api('youtube', 'v3')
      @results_no_stat = client.execute!(
        api_method: youtube.search.list,
        parameters: {
          part: 'id,snippet',
          q: @query,
          maxResults: 10,
          type: 'video',
        }
      )

      video_ids = @results_no_stat.data.items.collect do |result|
        result.id.videoId
      end

      @results = client.execute!(
        api_method: youtube.videos.list,
        parameters: {
          part: 'id,snippet,statistics',
          id: video_ids.join(",")
        }
      )
    else
      redirect_to action: "search", controller: "playlists", id: @playlist.id
    end
  end
end