//= require jquery.remotipart
$(document).ready(function()
{
    function productAutosave()
    {
        var $form = $('.edit_product'),
        productId = $form.attr('data-product-id');
        $.ajax(
        {
            url: '/admin/products/' + productId + '/autosave',
            type: 'PATCH',
            data: $form.serialize(),
            dataType: 'json',
            success: function (data)
            {
                $('#autosave-message').show();
                $('#autosave-message').html("<i class='icon-checkmark icon-green'></i> All Changes Saved");
            },
            error: function(xhr, evt, status)
            {
                $('#autosave-message').show();
                $('#autosave-message').html("<i class='icon-close icon-red'></i> Validation Failed");
            }
        });
    };

    setInterval(function()
    {
        productAutosave()
    }, 20000);
});