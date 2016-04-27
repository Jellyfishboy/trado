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
    redlight.animation.displayCart()

    // trado
    trado.tracking.init();
    trado.app.updateSelectedSku();
    trado.app.updateSelectedAccessory();

    trado.modal.loading('.paypal_checkout', '#paypalModal');
    trado.modal.loading('.confirm_order', '#confirmOrderModal');
    trado.modal.open('#estimate-delivery-service-price', '#estimateDeliveryModal');
    trado.modal.resetEstimateDeliveryModel();

    trado.app.selectDeliveryServicePrice();
    trado.app.updateDeliveryServicePrice();
    trado.app.duplicateAddress();
    trado.app.jsonErrors();
    
    // Initialise floating sidebar for checkout order summary
    $('.checkout-container .content, .checkout-container .sidebar').theiaStickySidebar(
    {
        additionalMarginTop: 70
    });
};
$(document).ready(ready);

$(document).ajaxComplete(function()
{
    trado.modal.open('.notify_me', '#notifyMeModal');
    trado.app.selectDeliveryServicePrice();
    trado.app.jsonErrors();
});