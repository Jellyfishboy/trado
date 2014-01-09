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
#= require redactor-rails
#= require spin
#= require jquery.spin

# Attach a function or variable to the global namespace
root = exports ? this

#####################################
#    Check if console exists (IE)   #
#####################################
log = (message) ->
  if typeof console is 'object' then console.log(message) else return null

$(document).ready ->
    update_sku()
    select_shipping()
    loading_animation_settings()

    $('#order_shipping_country').change ->
        unless @value is ""
        	$.ajax '/update_country',
        		type: 'GET'
        		data: {'country_id' : @value, 'tier_id' : $('.shipping-methods').attr 'data-tier' }
        		dataType: 'html'
        		success: (data) ->
        			$('.shipping-methods .control-group .controls').html data
        else 
            $('.shipping-methods .control-group .controls').html '<p class="shipping_notice">Select a shipping country to view the available shipping options.</p>'

    $('#update_quantity').click ->
        $('.edit_line_item').each ->
            $(@).submit()

    loading_modal('.paypal_checkout', '#paypalModal')
    loading_modal('.confirm_order', '#confirmOrderModal')

$(document).ajaxComplete ->
    update_sku()
    select_shipping()

# update_shipping_cost = ->
#     $('.shipping-methods .shipping_option').click ->
#         shipping = $(@).find('input[type="radio"]').val()
#         order = $('.shipping-methods').attr 'data-total'
#         $.get '/orders/new?shipping_id=' + shipping + '&order_total=' + order

# form_JSON_errors = ->
#     $('#errors .close').click -> 
#         $('#errors .modal-body ul').empty()
#         console.log "EMPTY"
#     $(document).on "ajax:error", "form", (evt, xhr, status, error) ->
#         errors = xhr.responseJSON.error
#         for message of errors
#             $('#errors .modal-body ul').append '<li>' + errors[message] + '</li>'
#         $('#errors').modal 'show'
loading_modal = (trigger, target) ->
    $(trigger).click ->
        $(target).modal 'show'
        $(target + ' .modal-body .loading_block').spin 'standard'

select_shipping = ->
    $('.shipping-methods .option').click ->
        $(@).find('input:radio').prop 'checked', true
        $('.option').removeClass 'active'
        $(@).addClass 'active'
    $('.shipping-methods .option input:radio').each ->
        $(@).parent().addClass 'active' if $(@).is ':checked'

update_sku = ->
    $('#line_item_sku_id').change ->
        sku_id = $('#line_item_sku_id').val()
        $.get '/update_sku?sku_id=' + sku_id

loading_animation_settings = ->
    $.fn.spin.presets.standard =
        lines: 9 # The number of lines to draw
        length: 0 # The length of each line
        width: 10 # The line thickness
        radius: 18 # The radius of the inner circle
        corners: 1 # Corner roundness (0..1)
        rotate: 0 # The rotation offset
        direction: 1 # 1: clockwise, -1: counterclockwise
        color: "#e54b5d" # #rgb or #rrggbb
        speed: 0.8 # Rounds per second
        trail: 42 # Afterglow percentage
        shadow: false # Whether to render a shadow
        hwaccel: false # Whether to use hardware acceleration
        className: "spinner" # The CSS class to assign to the spinner
        zIndex: 2e9 # The z-index (defaults to 2000000000)
        top: "auto" # Top position relative to parent in px
        left: "auto" # Left position relative to parent in px



