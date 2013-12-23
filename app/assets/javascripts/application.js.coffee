#= require jquery
#= require jquery_ujs
#= require underscore/underscore-min
#= require bootstrap.min
#= require jquery.carouFredSel-6.2.1-packed
#= require jquery-ui-1.10.3/js/jquery-ui-1.10.3.custom.min
#= require jquery-ui-1.10.3/touch-fix.min
#= require isotope/jquery.isotope.min
#= require bootstrap-tour/build/js/bootstrap-tour.min
#= require prettyphoto/js/jquery.prettyPhoto
#= require goMap/js/jquery.gomap-1.3.2.min
#= require custom
#= require modernizr.custom.56918

# Attach a function or variable to the global namespace
root = exports ? this

$(document).ready ->
    update_shipping_cost()
    form_JSON_errors()
    update_dimension()
    $('#country_selector').change ->
    	$.ajax '/update_country',
    		type: 'GET'
    		data: {'country_id' : @value, 'tier_id' : $('.shipping-methods').attr 'data-tier' }
    		dataType: 'html'
    		success: (data) ->
    			$('.shipping-methods').html data

    $('#estimate_shipping').click ->
        $.ajax '/estimate_shipping',
            type: 'GET'
            data: {'country_id' : $('#country_selector').val(), 'tier_id' : $(@).attr 'data-tier' }
            dataType: 'html'
            success: (data) ->
                $('#shipping_options').html data
        $('#shipping').modal 'show'
        return false

$(document).ajaxComplete ->
    update_shipping_cost()
    update_dimension()

update_shipping_cost = ->
    $('.shipping-methods .shipping_option').click ->
        shipping = $(@).find('input[type="radio"]').val()
        order = $('.shipping-methods').attr 'data-total'
        $.get '/orders/new?shipping_id=' + shipping + '&order_total=' + order

form_JSON_errors = ->
    $('#errors .continue').click -> 
        $('#errors ul').empty()
        console.log "EMPTY"
    $(document).on "ajax:error", "form", (evt, xhr, status, error) ->
        errors = xhr.responseJSON.error
        for message of errors
            $('#errors ul').append '<li>' + errors[message] + '</li>'
        $('#errors').modal 'show'

update_dimension = ->
    $('#line_item_dimension_id').change ->
        product_id = $('#line_item_dimension_id').parent().attr 'data-product'
        dimension_id = $('#line_item_dimension_id').val()
        $.get '/products/' + product_id + '?dimension_id=' + dimension_id



