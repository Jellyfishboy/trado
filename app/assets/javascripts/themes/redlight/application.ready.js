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
    trado.modal.loading('.paypal_checkout', '#paypalModal');
    trado.modal.loading('.confirm_order', '#confirmOrderModal');
    trado.modal.open('#estimate-delivery-service-price', '#estimateDeliveryModal');
    trado.app.updatePrice('/product/skus/?sku_id=', '&accessory_id=', '#cart_item_sku_id', '#cart_item_cart_item_accessory_accessory_id');
    trado.app.updatePrice('/product/accessories/?accessory_id=', '&sku_id=', '#cart_item_cart_item_accessory_accessory_id', '#cart_item_sku_id');
    trado.app.selectDeliveryServicePrice();
    trado.app.updateDeliveryServicePrice();
    trado.app.duplicateAddress();
    trado.app.jsonErrors();

    // Reset estimate shipping modal
    $('#estimateDeliveryModal').on('hidden', function () 
    {
        $('.modal select').val("");
        $('.delivery-service-prices .control-group .controls').html("<p class='delivery-service-price-notice'> elect a country to view the available delivery services.</p>");
    });

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