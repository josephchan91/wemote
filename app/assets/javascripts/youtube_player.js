// connect to server like normal
// var dispatcher = new WebSocketRails(window.location.host);

var dispatcher;

$(function() {
  dispatcher = new WebSocketRails(window.location.host + '/websocket');
  loadYouTubePlayer();
});

function loadNextTrack() {
  var playlistId = $.cookie('current_playlist_id');
  var urlStr = '/playlists/' + playlistId + '/next_track';

  $.ajax({
    url: urlStr
  }).done(function(response) {
    console.log('received next track');
    ytplayer = document.getElementById("ytplayer");
    ytplayer.loadVideoById(response['next_track_id']);
  });
}

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
  if (newState === 0) {
    loadNextTrack();
  }
}

function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("ytplayer");
  ytplayer.addEventListener("onStateChange", "onYouTubePlayerStateChange");

  var playlistId = $.cookie('current_playlist_id');

  var channel = dispatcher.subscribe(playlistId);
  channel.bind('track_added', function(data) {
    console.log('track added');
    loadNextTrack();
  });
}
