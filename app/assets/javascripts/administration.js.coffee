#= require jquery
#= require jquery_ujs
#= require admin/ace-elements.min
#= require admin/ace.min
#= require admin/bootstrap.min
#= require admin/bootstrap-tag.min
#= require admin/jquery-ui-1.10.3.custom.min
#= require admin/jquery.slimscroll.min
#= require admin/jquery.ui.touch-punch.min
#= require bootstrap-datepicker

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

$(document).ready ->
  duplicate_fields ".invoice_address", ".billing_textarea", ".delivery_textarea"
  disable_field '#invoice_vat_applicable', '#invoice_vat_number'

  $('.change_shipping').click ->
    order = $(@).attr 'id'
    $.get '/admin/orders?order_id=' + order

$(document).ajaxComplete ->
  $("[data-behaviour~=datepicker]").datepicker
    format: "dd/mm/yyyy"
    startDate: "0"
