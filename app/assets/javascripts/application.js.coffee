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
    $('#country_selector').change ->
    	$.ajax '/update_country',
    		type: 'GET'
    		data: {'country_id' : $('#country_selector').val() }
    		dataType: 'html'
    		success: (data) ->
    			$('#shipping_options').html data

