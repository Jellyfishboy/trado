var taxRate = "<%= Store::settings.tax_rate %>";
     
ready = function()
{
    soca.animation.loading();
    soca.animation.colourCaveat();
    
    soca.filter.tableRowTarget();
    soca.filter.products();

    soca.misc.taxField();
    soca.misc.multiSelect();
    soca.misc.updateTableHeight();

    soca.mobile.disableTooltips();
    soca.mobile.triggerMenu();

    trado.admin.copyCountries();
    trado.admin.setCountries();
    trado.admin.editOrder();
    trado.admin.updateOrder();
    trado.admin.dispatchOrderModal();
    trado.admin.dispatchOrder();
    trado.admin.deleteAttachment();
    trado.admin.showAttachment();
    trado.admin.newAttachment();
    // trado.admin.amendAttachments();
    trado.admin.deleteSku();
    trado.admin.newSku();
};

$(document).ready(ready);
$(document).on('page:change page:load', function()
{
    $('.redactor').redactor({
        replaceDivs: false,
        convertDivs: false,
        minHeight: 300
    });
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