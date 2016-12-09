var taxRate = gon.taxRate;
     
ready = function()
{
    trado.misc.clearAllIntervals();
    
    soca.animation.loading();
    soca.animation.colourCaveat();
    soca.animation.sidebarExtension();
    
    soca.index.tableRowTarget();
    soca.index.sort('#sort-product');
    soca.index.filter('#filter-product-category');
    soca.index.filter('#filter-stock');
    soca.index.filter('#filter-order-delivery');

    soca.misc.taxField();
    soca.misc.multiSelect();
    soca.misc.updateTableHeight();

    soca.mobile.disableTooltips();
    soca.mobile.triggerMenu();

    trado.admin.copyCountries();
    trado.admin.setCountries();

    trado.admin.editOrder();
    trado.admin.updateOrder();

    trado.admin.deleteAttachment();
    trado.admin.showAttachment();
    trado.admin.newAttachment();
    trado.admin.editAttachment();
    trado.admin.amendAttachments();

    trado.admin.deleteSku();
    trado.admin.newSku();
    trado.admin.editSku();
    trado.admin.amendSkus();

    trado.admin.newStockAdjustment();
    trado.admin.createStockAdjustments();
    trado.admin.collectionCreateStockAdjustment();

    trado.admin.newVariants();
    trado.admin.resetVariants();
    trado.admin.amendVariants();

    trado.admin.showTransaction();
};
function addStockAdjustmentfields(content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("sku_stock_adjustments", "g")
    $('#stock-adjustment-fields').append(content.replace(regexp, new_id));
    $('select.chosen').chosen();
}
function removeStockAdjustmentFields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".fields").hide();
}
$(document).ready(ready);
$(document).on('page:change page:load', function()
{
    trado.misc.clearAllIntervals();
    $('[data-toggle=tooltip]').tooltip('hide');
    $('.main .container').removeClass('fadeOut').addClass('animated fadeIn');
});
$(document).on('page:fetch', function()
{
    $('.main .container').addClass('animated fadeOut');
    return $('.loading5').addClass('active');
});

$(document).on("page:receive", function(){
    $('.loading-overlay').removeClass('active');
    return $('.loading5').removeClass('active');
});

$(document).ajaxComplete(function()
{
    soca.misc.taxField();
});