trado.animation =
{
    loadingSettings: function() 
    {
        $.fn.spin.presets.standard = 
        {
            lines: 9,
            length: 0,
            width: 10,
            radius: 18,
            corners: 1,
            rotate: 0,
            direction: 1,
            color: "#e54b5d",
            speed: 0.8,
            trail: 42,
            shadow: false,
            hwaccel: false,
            className: "spinner",
            zIndex: 2e9,
            top: "auto",
            left: "auto"
        };
    },

    alert: function(beforeElement, alertType, uniqueClass, message, delayCount)
    {
        $(beforeElement).before('<div class="alert alert-' + alertType + ' animated fadeInDown ' + uniqueClass + '">' + message + '</div>').delay(delayCount).queue(function(next)
        {
            $('.' + uniqueClass).addClass('fadeOutUp').delay(800).hide(1);
            next();
        });
    },

    loadingForm: function ()
    {
        $('form.loading-form input[type=submit]').click(function()
        {
            $(this).closest('form').spin('standard');
            $(this).closest('form').css('pointer-events', 'none');
        });
    }
}