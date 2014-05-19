trado.tracking =
{
    var tradoAnalyticsData, init;

    init = function() {
      var gaEnabled;
      gaEnabled = typeof _gaq === 'object' ? true : false;
      window.TGA = new tradoAnalyticsData(ga_enabled);
      $('body').on('click', '[data-tracking="true"]', function() {
        var $this, category, name;
        name = $this.attr('data-tracking-name');
        category = $this.attr('data-tracking-category');
        return window.TGA.send([name, category]);
      });
    };

    tradoAnalyticsData = (function() {
      function tradoAnalyticsData(enabled) {
        this.enabled = enabled;
        this.send();
      }

      tradoAnalyticsData.prototype.event = "click";

      tradoAnalyticsData.prototype.build = function(tracker) {
        if (tracker !== void 0) {
          this.name = tracker[0];
          this.category = tracker[1];
        }
        return ['_trackEvent', this.category, this.event, this.name];
      };

      tradoAnalyticsData.prototype.send = function(object) {
        if (this.enabled) {
          _gaq.push(this.build(object));
        }
      };

      return tradoAnalyticsData;

    })();

}