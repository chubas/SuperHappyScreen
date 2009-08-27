var tweets    = [];
var elements  = [];
var cycler    = 1;
var get_twitter = function() {
  $.getJSON(
    'http://search.twitter.com/search.json?&q=shdhmc+OR+shdh+OR+devhouse&json_callback=?&callback=?',
    function(data) {
      //var numResults = data.results.length;
      $.each(data.results.reverse(), function(i, result) {
        //console.log("Received: %i, %s", i, result.text);
        if(tweets.indexOf(result.id) == -1) {
          if(tweets.length == 15){
            tweets.shift();
            var e = elements.shift();
            e.fadeOut(2000, function() { e.remove(); });
            // TODO: Add animation
          }
          tweets.push(result.id);
          var new_elem = $('<p class="tweet ' + (cycler == 1 ? 'odd' : 'even') + '" style="display:none"/>').
                  html('<span>' + '<img src="' + result.profile_image_url + '" />' + result.from_user + '</span>: ' + result.text).
                  prependTo('#tw_space');
          new_elem.fadeIn(2000);
          elements.push(new_elem);
          cycler = 1 - cycler;
        }
      });
      //console.log(tweets);
    }
  );
};

get_twitter();
setInterval(get_twitter, 30 * 1000); 