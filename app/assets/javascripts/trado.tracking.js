trado.tracking =
{

    init: function() 
    {
        var gaEnabled;
        gaEnabled = typeof _gaq === 'object' ? true : false;
        $('body').on('click', '[data-tracking="true"]', function() 
        {
            var category, name;
            name = $(this).attr('data-tracking-name');
            category = $(this).attr('data-tracking-category');
            return trado.tracking.send(gaEnabled,[name, category]);
        });
    },

    build: function(object)
    {
        if (object != null)
        {
            return ['_trackEvent', object[1], 'click', object[1]];
        }
    },

    send: function(enabled, object)
    {
        if (enabled)
        {
            _gaq.push(trado.tracking.build(object));
            trado.misc.log(object);
        }
    },

}
// var tradoAnalyticsData;
// tradoAnalyticsData: (function() 
// {
//     function tradoAnalyticsData(enabled) 
//     {
//         this.enabled = enabled;
//         this.send();
//     }

//     tradoAnalyticsData.prototype.event = "click";

//     tradoAnalyticsData.prototype.build = function(tracker) 
//     {
//         if (tracker !== void 0) 
//         {
//             this.name = tracker[0];
//             this.category = tracker[1];
//         }
//         return ['_trackEvent', this.category, this.event, this.name];
//     };

//     tradoAnalyticsData.prototype.send = function(object) 
//     {
//         if (this.enabled) 
//         {
//             _gaq.push(this.build(object));
//             log(object);
//         }
//     };
//     return tradoAnalyticsData;
// })();