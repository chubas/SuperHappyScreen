/**
* Run Code: a jQuery Plugin
* @author: Trevor Morris (trovster)
* @url: http://www.trovster.com/lab/code/plugins/jquery.run-code.js
* @documentation: http://www.trovster.com/lab/plugins/run-code/
* @published: 11/09/2008
* @updated: 29/09/2008
* @requires: jQuery v.1.2.6 or above
*
*/
if(typeof jQuery != 'undefined') {
	jQuery(function($) {
		$.fn.extend({
			runcode: function(options) {
				var settings = $.extend({}, $.fn.runcode.defaults, options);

				return this.each(
					function() {
						if($.fn.jquery < '1.2.6') {return;}
						var $t = $(this);
						var o = $.metadata ? $.extend({}, settings, $t.metadata()) : settings;

						eval($t.text());
					}
				);
			}
		});

		/**
		* Plugin Defaults
		*/
		$.fn.runcode.defaults = {};
	});
}

/**
* Cheat Code: a jQuery Plugin
* @author: Trevor Morris (trovster)
* @url: http://www.trovster.com/lab/code/plugins/jquery.cheat-code.js
* @documentation: http://www.trovster.com/lab/plugins/cheat-code/
* @published: 10/05/2009
* @updated: 10/05/2009
* @license Creative Commons Attribution Non-Commercial Share Alike 3.0 Licence
*		   http://creativecommons.org/licenses/by-nc-sa/3.0/
*/
if(typeof jQuery != 'undefined') {
	jQuery(function($) {
		$.fn.extend({
			cheatCode: function(options) {
				var $$	= $(this),
					s	= $.extend({}, $.fn.cheatCode.defaults, options),
					o 	= $.metadata ? $.extend({}, s, $$.metadata()) : s,
					k	= [];

				return this.each(
					function() {
						$$.bind('keydown.cheatCode' + o.code.toString(), function(e){
							k.push(e.keyCode);
							if(k.toString().indexOf(o.code) >= 0){
								k = [];
								o.activated.call(this, o);
								unbind.call(this, o);
							}
						});
					}
				);
			}
		});

		var complete = function(o){
			var $overlay = $('<div class="overlay"></div>')
				$message = $('<div class="modal"></div>');

			$message.text(o.message).appendTo('body');
			$overlay.appendTo('body');
			setTimeout(function(){
				$message.fadeOut(500, function(){
					$(this).remove();
					$overlay.fadeOut(500, function(){
						$(this).remove();
					});
				});
			}, 1000);
		};

		var unbind = function(o){
			if(o.unbind===true) {
				$(this).unbind('keydown.cheatCode' + o.code.toString());
			}
		};

		$.fn.cheatCode.defaults = {
			'code' 		: '38,38,40,40,37,39,37,39,66,65',
			'unbind'	: true,
			'activated'	: complete,
			'message'	: 'Cheat Code Activated'
		};

	});
}
