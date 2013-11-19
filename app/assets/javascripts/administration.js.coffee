#= require jquery
#= require jquery_ujs
#= require admin/ace-elements.min
#= require admin/ace.min
#= require admin/bootstrap.min
#= require admin/bootstrap-tag.min
#= require admin/jquery-ui-1.10.3.custom.min
#= require admin/jquery.slimscroll.min
#= require admin/jquery.ui.touch-punch.min

# Attach a function or variable to the global namespace
root = exports ? this

root.remove_fields = (link) ->
  if $('.ajax_fields')
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

$(document).ready ->
  duplicate_fields ".invoice_address", ".billing_textarea", ".delivery_textarea"
