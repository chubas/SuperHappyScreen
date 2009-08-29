var tweets    = [];
var elements  = [];
var cycler    = 1;
var get_twitter = function() {
  $.getJSON(
    'http://search.twitter.com/search.json?&q=shdhmc+OR+shdh+OR+devhouse+OR+hackspedition&json_callback=?&callback=?',
    function(data) {
      //var numResults = data.results.length;
      $.each(data.results.reverse(), function(i, result) {
        //console.log("Received: %i, %s", i, result.text);
        if(tweets.indexOf(result.id) == -1) {
          if(tweets.length == 15){
            tweets.shift();
            var e = elements.shift();
            e.fadeOut(2000, function() { e.remove(); });
          }
          tweets.push(result.id);
          var new_elem = $('<div class="tweet ' + (cycler == 1 ? 'odd' : 'even') + '" style="display:none"/>').
                  html('<span>' + '<img src="' + result.profile_image_url + '" />' +
                         '<span class="tweet_user">' +
                            '<a href="http://twitter.com/' + result.from_user + '" target="new">' +
                              result.from_user +
                            '</a>' +
                         '</span>' +
                       '</span>: ' + result.text).
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

