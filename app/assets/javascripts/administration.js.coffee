#= require jquery
#= require jquery_ujs
#= require admin/soca
#= require bootstrap-tagsinput/dist/bootstrap-tagsinput.min 
#= require admin/bootstrap.min
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
  calculate_tax()

calculate_tax = ->
  $elem = $('.calculate_tax')
  $elem.each ->
    val = Number(@value)
    sum = val + (val*0.2)
    sum = 0 if isNaN(sum)
    $(@).closest('input').after '<div class="gross">Gross amount: ' + parseFloat(sum, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString() + '</div>'
  $elem.bind "input", ->
    val = Number(@value)
    sum = val + (val*0.2)
    sum = 0 if isNaN(sum)
    $(@).next('.gross').text 'Gross amount: ' + parseFloat(sum).toFixed(2)

form_JSON_errors = ->
  $(document).on "ajax:error", "form", (evt, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseJSON.errors)
      $.each errors, (key, value) ->
          $element = $("input[name*='" + key + "']")
          $error_target = '.error_explanation'
          if $element.parent().next().is $error_target
              $($error_target).html '<span>' + key + '</span> ' + value
          else 
              $element.wrap '<div class="field_with_errors"></div>'
              $element.parent().after '<span class="' + $error_target.split('.').join('') + '"><span>' + key + '</span> ' + value + '</span>'
  

$(document).ready ->
  calculate_tax()
  form_JSON_errors()

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