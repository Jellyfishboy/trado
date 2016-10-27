ready = function()
{
    // redlight
    new mlPushMenu(document.getElementById("mp-menu"),document.getElementById("trigger")),
    redlight.misc.changeListType(),
    redlight.misc.duplicateAddress(),
    redlight.misc.changeQuantity(),
    redlight.misc.scrollHelper(),
    redlight.misc.escapeSearch(),
    redlight.misc.displayCreditCardForm('#stripe-form-fields', 'stripe'),
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
function stripeCheckoutErrors()
{
    $('.checkout-body').prepend('<div class="errors stripe-error"><p>Please complete all of the required fields</p></div>');
    $('.checkout').prepend('<div class="alert alert-orange alert-stripe-checkout"><i class="icon-blocked"></i>An error ocurred with your order. Please try again.</div>');
}
function stripeTermsValidationMessage()
{
    $('<span class="error-explanation stripe-error-terms">You must tick the box in order to place your order.</span>').insertBefore('input[type="hidden"][name="order[terms]"]');
}