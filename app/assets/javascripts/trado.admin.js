trado.admin =
{
    jsonErrors: function()
    {
        $(document).on("ajax:error", "form", function(evt, xhr, status, error)
        {
            var content, value, _i, _len, _ref;
            content = $(this).children('#errors');
            content.find('ul').empty();
            _ref = $.parseJSON(xhr.responseText).errors;
            // Append errors to list on page
            for (_i = 0, _len = _ref.length; _i < _len; _i++)
            {
                value = _ref[_i];
                content.show().find('ul').append('<li><i class="icon-cancel-circle"></i>' + value + '</li>');
            }
            // Scroll to error list
            if (!$(this).parent().hasClass('modal-content'))
            {
                $('body').scrollTo('.page-header', 800);
            }
            // Fade out loading animation
            $('.loading-overlay').css('height', '0').removeClass('active');
            $('.loading5').removeClass('active');
            // Reset attachment styles
            $('.new-file').css('background-color', '#00aff1').children('.icon-upload-3').css('top', '41px');
            return $('.new-file').children('div').empty();
      });
    },

    copyCountries: function()
    {
        $('body').on('click', '#copy-countries', function ()
        {
            var currentDeliveryService = $(this).attr('data-delivery-service-id');
            $.ajax(
            {
                url: '/admin/delivery_services/copy_countries',
                type: "GET",
                data: { delivery_service_id: currentDeliveryService },
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#delivery-service-modal').html(data.modal);
                    soca.modal.standard('#delivery-service-form');
                }
            });
            return false;
        });
    },

    setCountries: function()
    {
        $('body').on('click', '#set-countries', function ()
        {
            var currentDeliveryService = $('#delivery_service_id').val(),
                errorContent = $('#delivery-service-form #errors');
            $.ajax(
            {
                url: '/admin/delivery_services/set_countries',
                type: "POST",
                data: { delivery_service_id: currentDeliveryService },
                dataType: "json",
                success: function(data)
                {
                    $('#delivery_service_country_ids').val(data.countries);
                    $('#delivery_service_country_ids').trigger('chosen:updated');
                    $('#delivery-service-form').modal('hide');
                },
                error: function(xhr, status, error)
                {
                    errorContent.find('ul').empty();
                    errorContent.show().find('ul').append('<li><i class="icon-cancel-circle"></i>' + xhr.responseJSON.errors + '</li>');
                }
            });
            return false;
        });
    },

    editOrder: function()
    {
        $('body').on('click', '#edit-record', function ()
        {
            var orderId = $(this).attr('data-record-id');
            $.ajax(
            {
                url: '/admin/orders/' + orderId + '/edit',
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#order-modal').html(data.modal);
                    soca.modal.standard('#order-form');
                }
            });
            return false;
        });
    },

    updateOrder: function()
    {
        $("body").on("submit", '.edit_order', function() 
        {
            var orderId = $(this).attr('id');
            $.ajax(
            {
                url: '/admin/orders/' + orderId,
                type: 'PATCH',
                data: $(this).serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#order-form').modal('hide');
                    soca.animation.alert(
                        '.widget-header', 
                        'success', 
                        'order-update-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully updated Order #' + data.order_id + '.',
                        5000
                    )     
                }
            });
            return false;
        });
    },

    dispatchOrderModal: function()
    {
        $('body').on('click', '#dispatcher', function()
        {
            var orderId = $(this).attr('data-order-id');
            $.ajax(
            {
                url: '/admin/orders/' + orderId + '/dispatcher',
                type: 'GET',
                dataType: 'json',
                success: function (data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#dispatch-order-modal').html(data.modal);
                    soca.modal.standard('#dispatch-order-form');
                }
            });
            return false;
        });
    },

    dispatchOrder: function()
    {
        $('body').on('click', '#dispatch-order', function()
        {
            var orderId = $(this).attr('data-order-id');
            $.ajax(
            {
                url: '/admin/orders/' + orderId + '/dispatched',
                type: 'POST',
                dataType: 'json',
                success: function (data)
                {
                    $('#dispatch-order-form').modal('hide');
                    $('tr#order_' + data.order_id).html(data.row);
                    soca.animation.alert(
                        '.widget-header', 
                        'success', 
                        'dispatch-order-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully updated Order #' + data.order_id + ' as being dispatched on ' + data.date + '.',
                        5000
                    )
                }
            });
        });
    }
}