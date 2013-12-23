(function($) {
	$.goMapProgressBar = function(map, options) {
		var bar = this;
		bar.map = map;
		bar.options = options || {}; 
		
		bar.init = function() {
			bar.width = bar.options.width || 176;
			bar.loadstring = bar.options.loadstring || 'Loading...';
			bar.operations = 0;
			bar.current = 0;

			var container = '<div id="geo_progress_container" style="position:absolute;display:none;z-index:1001;width:' + bar.width + 'px;height:20px;border:1px solid #555;background-color:#fff;text-align:left;font-size:0.8em;">'
				+ '<div style="position:absolute;width:100%;border:5px;text-align:center;vertical-align:bottom;" id="geo_progress_text">asd</div>'
				+ '<div style="background-color:green;height:100%;" id="geo_progress"></div>'
				+ '</div>';

  			$(bar.map).append(container);

			bar.div_ = $('#geo_progress');
			bar.text_ = $('#geo_progress_text');
			bar.container_ = $('#geo_progress_container');
		};
		
		bar.start = function() {
			var operations = $(bar.map).data('goMap').getTmpMarkerCount();
			bar.operations = operations || 0;
			bar.current = 0;
			bar.div_.css({'width':'0%'});
			bar.text_.css({'color':'#111'}).html(bar.loadstring);
			bar.container_.css({'display':'block'});
			
			bar.countDown();
		};

		bar.updateLoader = function(step) {
			bar.current = step;
			if (bar.current > 0) {
				var percentage_ = Math.ceil((bar.current / bar.operations) * 100);
				if (percentage_ > 100) 
      				percentage_ = 100; 
			    bar.div_.css({'width':percentage_ + '%'});
			    bar.text_.html(bar.current + ' / ' + bar.operations); 
  			}
		};

		bar.remove = function() {
			bar.container_.hide();
		};

		bar.countDown = function() {
			var goMap = $(bar.map).data('goMap');
			var count = goMap.getMarkerCount();
			if(goMap.getTmpMarkerCount() > count) {
				bar.updateLoader(count);
				setTimeout(function() {
					bar.countDown();
				}, 200);
			}
			else
				bar.remove();
		};
		bar.init();		
	};
 
})(jQuery);
