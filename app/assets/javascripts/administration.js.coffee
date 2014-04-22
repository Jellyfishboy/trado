#= require jquery
#= require jquery_ujs
#= require admin/soca
#= require admin/bootstrap.min
#= require jquery.scrollTo/jquery.scrollTo.min

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
      array = $.parseJSON(xhr.responseText)
      content = $(@).children('#errors')
      content.find('ul').empty()
      for value in array.errors
          content.show().find('ul').append '<li><i class="icon-cancel-circle"></i>' + value + '</li>'
      $('body').scrollTo('.page-header', 800) unless $(@).parent().hasClass 'modal-content'
      $('.new-file').css('background-color', '#00aff1').children('.icon-upload-3').css('top', '41px')
      $('.new-file').children('div').empty()
      
$(document).ready ->
  calculate_tax()
  form_JSON_errors()

  $('.order_shipping').click ->
    order = $(@).attr 'id'
    $.get '/admin/orders/' + order + '/shipping'

  $('.edit_order_attributes').click ->
    order = $(@).attr 'id'
    $.get '/admin/orders/' + order + '/edit'

  $('body').on 'click', '.new_stock_levels', ->
    sku = $(@).attr 'id'
    $.get '/admin/products/skus/stock_levels/new?sku_id=' + sku

  $('body').on 'click', '.edit_sku_attributes', ->
    sku = $(@).attr 'id'
    $.get '/admin/products/skus/' + sku + '/edit'

  # Copy SKU Prefix
  # if $("#product_sku").is ':visible'
  #   window.setInterval (->
  #     $(".sku_prefix").text $("#product_sku").val() + '-'
  #   ), 100
