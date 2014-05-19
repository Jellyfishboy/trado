//= require jquery
//= require jquery_ujs
//= require admin/soca
//= require admin/bootstrap.min
//= require jquery.scrollTo/jquery.scrollTo.min
//= require _trado
//= require trado.misc
//= require trado.modal
//= require trado.admin

// Attach a function or variable to the global namespace
// root = exports ? this

// root.remove_fields = (link, obj) ->
//   $elements = $('.' + obj + '.ajax-fields')
//   if $elements.length > 1 || $elements.parent().hasClass 'edit_field'
//     $(link).prev("input[type=hidden]").val "1"
//     $elem = $(link).closest(".ajax-fields")
//     $elem.next("input[type=file]").remove() if obj == "attachments"
//     $elem.remove()
// root.add_fields = (link, association, content, target) ->
//   new_id = new Date().getTime()
//   regexp = new RegExp("new_" + association, "g")
//   $(target).append content.replace(regexp, new_id)
      
$(document).ready(function() {

  trado.app.taxField();
  trado.admin.jsonErrors();

  trado.modal.ajaxOpen('.order_shipping', '/admin/orders/', '/shipping');
  trado.modal.ajaxOpen('.edit_order_attributes', '/admin/orders/', '/edit');
  trado.modal.ajaxOpen('.new_stock_levels', '/admin/products/skus/stock_levels/new?sku_id=', null);
  trado.modal.ajaxOpen('.edit_sku_attributes', '/admin/products/skus/', '/edit');
  trado.modal.ajaxOpen('.edit_transaction_attributes', '/admin/transactions/', '/edit');

});
