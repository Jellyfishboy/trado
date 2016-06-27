ready = function()
{
    // redlight
    new mlPushMenu(document.getElementById("mp-menu"),document.getElementById("trigger")),
    redlight.misc.changeListType(),
    redlight.misc.duplicateAddress(),
    redlight.misc.changeQuantity(),
    redlight.misc.scrollHelper(),
    redlight.misc.escapeSearch(),
    redlight.animation.imageGallery(),
    redlight.animation.displaySearch(),
    redlight.animation.cartPopup(),
    redlight.animation.autoHideCartPoup();
    redlight.animation.displayCart();

    // trado
    trado.tracking.init();
    trado.app.updateSelectedSku();
    trado.app.updateSelectedAccessory();

    trado.modal.loading('.checkout-button', '#checkoutLoadingModal');
    trado.modal.open('#estimate-delivery-service-price', '#estimateDeliveryModal');
    trado.modal.resetEstimateDeliveryModel();

    trado.app.setDeliveryServicePrices();
    trado.app.selectDeliveryServicePrice();
    trado.app.updateDeliveryServicePrice();
    trado.app.addToCart();
    trado.app.deleteCartItem();
    trado.app.updateCartItem();
    trado.app.notifyMe();
    trado.app.createNotifyMe();
    trado.app.sendContactMessage();
    
    // Initialise floating sidebar for checkout order summary
    $('.checkout-container .content, .checkout-container .sidebar').theiaStickySidebar(
    {
        additionalMarginTop: 70
    });
};
$(document).ready(ready);
$(window).load(function()
{
    redlight.animation.checkoutOrderSummaryHeight();
});
$(document).ajaxComplete(function()
{
    trado.modal.open('.notify_me', '#notifyMeModal');
    trado.app.selectDeliveryServicePrice();
});