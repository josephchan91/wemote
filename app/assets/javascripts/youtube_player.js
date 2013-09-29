function loadYouTubePlayer() {
  var params = { allowScriptAccess: "always" };
  var atts = { id: "myytplayer" };
  // change this url later, it's pointing to a kanye west video
  var url = "http://www.youtube.com/v/x36nVPJWVdk?enablejsapi=1&playerapiid=ytplayer&version=3";
  $('body').css('background-color', 'red');
  swfobject.embedSWF(
    url,
    "ytapiplayer",
    "425",
    "356",
    "8",
    null,
    null,
    params,
    atts
  );
}

function onYouTubePlayerReady(playerId) {
  ytplayer = document.getElementById("ytapiplayer");
  ytplayer.play();
}
