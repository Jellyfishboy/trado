#= require jquery
#= require jquery_ujs
#= require bootstrap_custom
#= require jquery-ui-1.10.2.custom
#= require jquery.easing-1.3.min
#= require jquery.isotope.min
#= require jquery.flexslider
#= require jquery.elevatezoom
#= require jquery.sharrre-1.3.4
#= require jquery.gmap3
#= require la_boutique
#= require imagesloaded
#= require modernizr-2.6.2.min

# Attach a function or variable to the global namespace
root = exports ? this

$(document).ready ->
    update_shipping_cost()
    form_JSON_errors()
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

update_shipping_cost = ->
    $('.shipping-methods input[type="radio"]').change ->
        shipping = $(@).val()
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

root.update_country = (content, target) ->
    $(target).empty().html content



