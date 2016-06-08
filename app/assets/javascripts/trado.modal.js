trado.modal =
{
    loading: function(trigger, target) 
    {
        $(trigger).click(function() 
        {
            $(target).modal(
            {
                backdrop: 'static',
                keyboard: false
            });
        });
    },
    
    open: function(trigger, target)
    {
        $(trigger).click(function() 
        {
           $(target).modal('show');
           return false;
        });
    },

    ajaxOpen: function(elem, url, urlEnd)
    {   
        $('body').on('click', elem, function() 
        {
            // Stop the page transition animation style disabling the z-index order for the modal
            $('.main .container').removeClass('fadeIn');
            var id;
            id = $(this).attr('id');
            if (urlEnd)
            {
                return $.get(url.concat(id, urlEnd));
            }
            else
            {
                return $.get(url.concat(id));
            }
        });
    },

    resetEstimateDeliveryModel: function()
    {
        $('#estimate-delivery-modal').on('hidden', function () 
        {
            $('.modal select').val("");
            $('.delivery-service-prices .control-group .controls').html("<p class='delivery-service-price-notice'> elect a country to view the available delivery services.</p>");
        });
    }
}