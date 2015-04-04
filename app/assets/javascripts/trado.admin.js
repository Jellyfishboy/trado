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
        var currentDeliveryService = $('#copy-countries').attr('data-delivery-service-id');
        $('body').on('click', '#copy-countries', function ()
        {
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
    }
}