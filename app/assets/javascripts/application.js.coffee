#= require jquery
#= require jquery_ujs
#= require bootstrap.min
#= require modernizr-2.6.2.min

$(document).ready ->
    $('#line_item_dimension_id').change ->
        $.ajax '/update_price',
            type: 'GET'
            data: {'dimension_id' : $('#line_item_dimension_id').val() }
            dataType: 'html'
            success: (data) ->
                $('.price').html data
