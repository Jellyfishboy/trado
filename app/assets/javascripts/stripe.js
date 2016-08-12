var order;

jQuery(function() {
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  return order.setupForm();
});

order = {
  setupForm: function() {
    return $('#new_order').submit(function() {
      $('input[type=submit]').attr('disabled', true);
      if ($('#card_number').length) {
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
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    };
    return Stripe.createToken(card, order.handleStripeResponse);
  },
  handleStripeResponse: function(status, response) {
    if (status === 200) {
      $('#order_stripe_card_token').val(response.id);
      return $('#new_order')[0].submit();
    } else {
      $('#stripe_error').text(response.error.message);
      return $('input[type=submit]').attr('disabled', false);
    }
  }
};