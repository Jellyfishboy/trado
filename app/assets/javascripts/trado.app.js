trado.app =
{
    updatePrice: function(url, queryString, elem, elemTwo)
    {
        $(elem).change(function() 
        {
            var id, idTwo;
            id = $(this).val();
            idTwo = $(elemTwo).val();
            return $.get(url.concat(id, queryString, idTwo));
        });
    },

    jsonErrors: function() 
    {
        $(document).on("ajax:error", "form.remote-form", function(evt, xhr, status, error) 
        {
            var errors;
            errors = $.parseJSON(xhr.responseJSON.errors);
            $.each(errors, function(key, value) 
            {
                var $element, $errorTarget;
                tempKey = key.split('_');
                key = tempKey[tempKey.length-1] == "id" ? tempKey[0] : key
                $element = $("input[name*='" + key + "']");
                if ($element.length == 0)
                {
                    $element =  $("select[name*='" + key + "']");
                }
                $errorTarget = '.error-explanation';
                if ($element.parent().next().is($errorTarget)) 
                {
                    return $($errorTarget).html('<span>' + key + '</span> ' + value);
                } 
                else 
                {
                    $element.wrap('<div class="field-with-errors"></div>');
                    return $element.parent().after('<span class="' + $errorTarget.split('.').join('') + '"><span>' + key + '</span> ' + value + '</span>');
                }
            });
        });
    },

    typeahead: function() 
    {
        $("#navSearchInput").typeahead(
        {
            remote: "/search/autocomplete?utf8=✓&query=%QUERY",
            template: " <div class='inner-suggest'> <img src='{{image.file.url}}' height='45' width='45'/> <span> <div>{{value}}</div> <div>{{category_name}}{{}}</div> </span> </div>",
            engine: Hogan,
            limit: 4
        }).on("typeahead:selected", function($e, data) 
        {
            return window.location = "/categories/" + data.category_slug + "/products/" + data.product_slug;
        });
    },

    duplicateAddress: function() 
    {
        $('.use-billing-address').change(function() 
        {
            if (this.checked) 
            {
                $('.use-billing').each(function() 
                {
                    return $(this).val($(this).next('div').text());
                });
                $('.field_with_errors').each(function() 
                {
                    return $(this).children('input').val($(this).next('div').text());
                });
            } 
            else 
            {
                return $('.use-billing').val('');
            }
        });
    },

    selectDeliveryServicePrice: function() 
    {
        $('.delivery-service-prices .option').click(function() 
        {
            $(this).find('input:radio').prop('checked', true);
            $('.option').removeClass('active');
            return $(this).addClass('active');
        });
        $('.delivery-service-prices .option input:radio').each(function() 
        {
            if ($(this).is(':checked')) 
            {
                return $(this).parent().addClass('active');
            }
        });
    },

    updateDeliveryServicePrice: function()
    {
        $('.update-delivery-service-price select').change(function() 
        {
            if (this.value !== "") 
            {
                $.ajax('/order/delivery_service_prices/update', 
                {
                    type: 'GET',
                    data: 
                    {
                        'country_id': this.value
                    },
                    dataType: 'html',
                    success: function(data) 
                    {
                        return $('.delivery-service-prices .control-group .controls').html(data);
                    }
                });
            } 
            else 
            {
                return $('.delivery-service-prices .control-group .controls').html('<p class="delivery_service_prices_notice">Select a delivery country to view the available delivery prices.</p>');
            }
        });
    },

    submitAll: function()
    {
        $('#update_quantity').click(function() 
        {
            $('.edit_cart_item').each(function() 
            {
                return $(this).submit();
            });
        });
    }
}