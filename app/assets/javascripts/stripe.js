var order;

jQuery(function() {
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  return order.setupForm();
});

order = {
  setupForm: function() {
    return $('.process_order').submit(function() {
      $('input[type=submit]').attr('disabled', true);
      if ($('#stripe_card_number').length) {
        order.processCard();
        return false;
      } else {
        return true;
      }
    });
  },
  processCard: function() {
    var card;
    card = {
      number: $('#stripe_card_number').val(),
      cvc: $('#stripe_card_code').val(),
      expMonth: $('#stripe_card_month').val(),
      expYear: $('#stripe_card_year').val()
    };
    return Stripe.createToken(card, order.handleStripeResponse);
  },
  handleStripeResponse: function(status, response) {
    if (status === 200) {
      $('#order_stripe_card_token').val(response.id);
      return $('.process_order')[0].submit();
    } else {
      $('#stripe_error').text(response.error.message);
      $('#checkoutLoadingModal').modal('hide');
      return $('input[type=submit]').attr('disabled', false);
    }
  }
};