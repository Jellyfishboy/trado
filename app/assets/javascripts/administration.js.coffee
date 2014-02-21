#= require jquery
#= require jquery_ujs
#= require bootstrap-datepicker
#= require admin/saturn_1
#= require redactor-rails

# Attach a function or variable to the global namespace
root = exports ? this

root.remove_fields = (link, obj) ->
  $element = $('.' + obj + '.ajax_fields')
  if $element.length > 1 || $element.parent().hasClass 'edit_field'
    $(link).prev("input[type=hidden]").val "1"
    $(link).closest(".ajax_fields").remove()
root.add_fields = (link, association, content, target) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(target).append content.replace(regexp, new_id)
duplicate_fields = (checkbox, field_one, field_two) ->
  $(checkbox).change ->
    if @checked
      $(field_two).val $(field_one).val()
    else
      $(field_two).val ""
disable_field = (checkbox, field) ->
  $(checkbox).change ->
    console.log "test"
    if @checked
      $(field).prop 'readonly', false
    else
      $(field).val '0'
      $(field).prop 'readonly', true

calculate_tax = ->
  # $elem = $('.calculate_tax')
  $('.calculate_tax').each ->
    val = Number(@value)
    sum = val + (val*0.2)
    sum = 0 if isNaN(sum)
    $(@).closest('input').after '<div id="gross">Gross amount: ' + parseFloat(sum, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString() + '</div>'
  $('.calculate_tax').bind "input", ->
    val = Number(@value)
    sum = val + (val*0.2)
    sum = 0 if isNaN(sum)
    unless $('#gross').length > 0
      $(@).closest('input').after '<div id="gross">Gross amount: ' + parseFloat(sum, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString() + '</div>'
    else
      $('#gross').text 'Gross amount: ' + parseFloat(sum).toFixed(2)
  

$(document).ready ->
  calculate_tax()

  $('.change_shipping').click ->
    order = $(@).attr 'id'
    $.get '/admin/orders?order_id=' + order + '&update_type=shipping'

  $('.add_actual_shipping_cost').click ->
    order = $(@).attr 'id'
    $.get '/admin/orders?order_id=' + order + '&update_type=actual_shipping_cost'

  $('.update_stock').click ->
    sku = $(@).attr 'id'
    $.get '/admin/products/skus?sku_id=' + sku

  # Copy SKU Prefix
  if $("#product_sku").is ':visible'
    window.setInterval (->
      $(".sku_prefix").text $("#product_sku").val() + '-'
    ), 100


$(document).ajaxComplete ->
  $("[data-behaviour~=datepicker]").datepicker
    format: "dd/mm/yyyy"
    startDate: "0"
  calculate_tax()
