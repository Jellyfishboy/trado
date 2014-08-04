//= require trado.filter

productReady = function()
{
    trado.filter.tableRowTarget();
    trado.filter.products();
};
$(document).ready(ready);
$(document).on('page:load', productReady)