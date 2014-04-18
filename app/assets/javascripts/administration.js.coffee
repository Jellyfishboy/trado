#= require jquery
#= require jquery_ujs
#= require admin/soca
#= require bootstrap-tagsinput/dist/bootstrap-tagsinput.min 
#= require admin/bootstrap.min
#= require jquery.scrollTo/jquery.scrollTo.min
#= require redactor-rails

# Attach a function or variable to the global namespace
root = exports ? this

root.remove_fields = (link, obj) ->
  $elements = $('.' + obj + '.ajax-fields')
  if $elements.length > 1 || $elements.parent().hasClass 'edit_field'
    $(link).prev("input[type=hidden]").val "1"
    $elem = $(link).closest(".ajax-fields")
    $elem.next("input[type=file]").remove() if obj == "attachments"
    $elem.remove()
root.add_fields = (link, association, content, target) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(target).append content.replace(regexp, new_id)
  # calculate_tax()

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
      errors = xhr.responseJSON.errors
      $('#errors ul').empty()

      for value in errors
          $('#errors').show().find('ul').append '<li><i class="icon-cancel-circle"></i>' + value + '</li>'
      $('body').scrollTo '.page-header', 800

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
  # if $("#product_sku").is ':visible'
  #   window.setInterval (->
  #     $(".sku_prefix").text $("#product_sku").val() + '-'
  #   ), 100


# $(document).ajaxComplete ->
  # $("[data-behaviour~=datepicker]").datepicker
  #   format: "dd/mm/yyyy"
  #   startDate: "0"