//= require jquery
//= require jquery_ujs
//= require_tree .


function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".ajax_fields").remove();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id));
}