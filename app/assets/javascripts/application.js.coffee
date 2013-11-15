#= require jquery
#= require jquery_ujs
#= require bootstrap.min
#= require modernizr-2.6.2.min

$(document).ready ->
    update_shipping_cost()
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
    		data: {'country_id' : $('#country_selector').val(), 'tier_id' : $('#shipping_options').attr 'data-tier' }
    		dataType: 'html'
    		success: (data) ->
    			$('#shipping_options').html data

$(document).ajaxComplete ->
    update_shipping_cost()

update_shipping_cost = ->
    $('#shipping_options input[type="radio"]').change ->
        $.ajax '/update_shipping',
            type: 'GET'
            data: {'shipping_id' : $(@).val() }
            dataType: 'html'
            success: (data) ->
                $('#shipping_value').html data

