function loadYouTubePlayer() {
  var params = { allowScriptAccess: "always" };
  var atts = { id: "ytplayer" };
  // change this url later, it's pointing to a kanye west video
  var url = "http://www.youtube.com/v/x36nVPJWVdk?enablejsapi=1&playerapiid=ytplayer&version=3";
  swfobject.embedSWF(
    url,
    "ytplayercontainer",
    "425",
    "356",
    "8",
    null,
    null,
    params,
    atts
  );
}

function onYouTubePlayerStateChange(newState) {
  // check if video has ended
  var playlistId = $.cookie('current_playlist_id');
  var urlStr = '/playlists/' + playlistId + '/next_track';
  console.log(urlStr);
  if (newState === 0) {
    $.ajax({
      url: urlStr
    }).done(function(response) {
      ytplayer = document.getElementById("ytplayer");
      ytplayer.loadVideoById(response['next_track_id']);
    });
  }
}

function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("ytplayer");
  ytplayer.addEventListener("onStateChange", "onYouTubePlayerStateChange");
}
