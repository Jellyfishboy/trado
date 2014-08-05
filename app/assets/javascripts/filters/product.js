//= require trado.filter

ready = function()
{
    trado.filter.tableRowTarget();
    trado.filter.products();
};
$(document).ready(ready);
$(document).on('page:load', ready)