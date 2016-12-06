trado.admin =
{
    jsonErrors: function(xhr, evt, status, form)
    {
        var content, value, _i, _len, _ref, $this;
        $this = form;
        content = $this.children('#errors');
        content.find('ul').empty();
        _ref = $.parseJSON(xhr.responseText).errors;
        // Append errors to list on page
        for (_i = 0, _len = _ref.length; _i < _len; _i++)
        {
            value = _ref[_i];
            content.show().find('ul').append('<li><i class="icon-cancel-circle"></i>' + value + '</li>');
        }
        // Scroll to error list
        if (!$this.parent().hasClass('modal-content'))
        {
            $('body').scrollTo('.page-header', 800);
        }
        // Fade out loading animation
        $('.loading-overlay').css('height', '0').removeClass('active');
        $('.loading5').removeClass('active');
    },

    copyCountries: function()
    {
        $('body').on('click', '#copy-countries', function ()
        {
            var currentDeliveryService = $(this).attr('data-delivery-service-id');
            $.ajax(
            {
                url: '/admin/delivery_services/copy_countries',
                type: "GET",
                data: { delivery_service_id: currentDeliveryService },
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#delivery-service-modal').html(data.modal);
                    soca.modal.standard('#delivery-service-form');
                }
            });
            return false;
        });
    },

    setCountries: function()
    {
        $('body').on('click', '#set-countries', function ()
        {
            var currentDeliveryService = $('#delivery_service_id').val(),
                errorContent = $('#delivery-service-form #errors');
            $.ajax(
            {
                url: '/admin/delivery_services/set_countries',
                type: "POST",
                data: { delivery_service_id: currentDeliveryService },
                dataType: "json",
                success: function(data)
                {
                    $('#delivery_service_country_ids').val(data.countries);
                    $('#delivery_service_country_ids').trigger('chosen:updated');
                    $('#delivery-service-form').modal('hide');
                },
                error: function(xhr, status, error)
                {
                    errorContent.find('ul').empty();
                    errorContent.show().find('ul').append('<li><i class="icon-cancel-circle"></i>' + xhr.responseJSON.errors + '</li>');
                }
            });
            return false;
        });
    },

    editOrder: function()
    {
        $('body').on('click', '.edit-order-record', function ()
        {
            var orderId = $(this).attr('data-record-id');
            $.ajax(
            {
                url: '/admin/orders/' + orderId + '/edit',
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#order-modal').html(data.modal);
                    soca.modal.standard('#order-form');
                }
            });
            return false;
        });
    },

    updateOrder: function()
    {
        $("body").on("submit", '.edit_order', function() 
        {
            var $this = $(this),
                orderId = $this.attr('id');
            $.ajax(
            {
                url: '/admin/orders/' + orderId,
                type: 'PATCH',
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#order-form').modal('hide');
                    $('tr#order_' + data.order_id).html(data.row);
                    soca.animation.alert(
                        '.widget-header', 
                        'success', 
                        'dispatch-order-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully updated Order #' + data.order_id + ' as being dispatched on ' + data.date + '.',
                        5000
                    )    
                },
                error: function(xhr, evt, status)
                {
                    trado.admin.jsonErrors(xhr, evt, status, $this);
                }
            });
            return false;
        });
    },

    deleteAttachment: function()
    {
        $('body').on('click', '.attachment-delete', function()
        {
            var url = $(this).attr('data-url');
            $.ajax(
            {
                url: url,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    if (data.last_record)
                    {
                        $('#attachments').html(data.html)
                    }
                    else
                    {
                        $("#attachment-" + data.attachment_id).remove();
                    }
                    soca.animation.alert(
                        '#attachments',
                        'success',
                        'attachment-destroy-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully deleted the image.',
                        3500
                    )
                }
            });
            return false;
        });
    },

    showAttachment: function()
    {
        $('body').on('click', '.show-attachment', function ()
        {
            var productId = $(this).attr('data-product-id');
            var attachmentId = $(this).attr('data-attachment-id');
            $.ajax(
            {
                url: '/admin/products/' + productId + '/attachments/' + attachmentId,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#attachment-preview-modal').html(data.modal);
                    soca.modal.standard('#attachment-preview-form');
                }
            });
            return false;
        });
    },

    newAttachment: function()
    {
        $('body').on('click', '#add-image', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#attachment-modal').html(data.modal);
                    soca.modal.standard('#attachment-form');
                }
            });
            return false;
        });
    },

    editAttachment: function()
    {
        $('body').on('click', '.edit-attachment', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#attachment-modal').html(data.modal);
                    soca.modal.standard('#attachment-form');
                }
            });
            return false;
        });
    },

    amendAttachments: function()
    {
        $('body').on('submit', '#amend_attachment', function(event)
        {
            event.stopPropagation(); // Stop stuff happening
            event.preventDefault(); // Totally stop stuff happening

            var $this = $(this);
                url = $this.attr('action');
                method = $this.attr('data-method'),
                message = method === 'POST' ? 'created' : 'edited';
                formData = new FormData(),
                serializedData = trado.misc.getUrlVars($(this).serialize());

            formData.append('attachment[file]', $('#attachment_file')[0].files[0])
            formData.append('attachment[default_record', serializedData['attachment[default_record]'])

            $.ajax(
            {
                url: url,   
                type: method,
                data: formData,
                cache: false,
                processData: false,
                contentType: false,
                success: function (data)
                {
                    $('#attachment-form').modal('hide');
                    $('#attachments').html(data.images);
                    soca.animation.alert(
                        '#attachments', 
                        'success', 
                        'amend-attachment-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully ' + message + ' an image.',
                        5000
                    )
                },
                error: function(xhr, evt, status)
                {

                    trado.admin.jsonErrors(xhr, evt, status, $this);
                }
            });
            return false;
        });
    },

    deleteSku: function()
    {
        $('body').on('click', '.sku-delete', function()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    if (data.last_record)
                    {
                        $('#add-sku-button').addClass('hide');
                        $('#skus').html('<div class="helper-notification"><p>You do not have any variants for this product.</p><i class="icon-tags"></i></div>')
                    }
                    else
                    {
                        $("#sku-" + data.sku_id).remove();
                    }
                    soca.animation.alert(
                        '#skus',
                        'success',
                        'sku-destroy-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully deleted the variant.',
                        3500
                    )
                }
            });
            return false;
        });
    },

    newSku: function()
    {
        $('body').on('click', '#add-sku-button', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#sku-modal').html(data.modal);
                    soca.modal.standard('#sku-form');
                }
            });
            return false;
        });
    },

    editSku: function()
    {
        $('body').on('click', '.edit-sku-button', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#sku-modal').html(data.modal);
                    soca.modal.standard('#sku-form');
                }
            });
            return false;
        });
    },

    amendSkus: function()
    {
        $('body').on('submit', '.amend-sku', function()
        {
            var $this = $(this),
                url = $this.attr('action'),
                method = $this.attr('data-method'),
                messageVerb;
                
            $.ajax(
            {
                url: url,
                type: method,
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#sku-form').modal('hide');
                    if (method === 'POST')
                    {
                        messageVerb = 'created';
                        $('#sku-fields').append("<tr id=\'sku-" + data.sku_id + "\'>" + data.row +"</tr>");
                    }
                    else
                    {   
                        messageVerb = 'updated';
                        $('tr#sku-' + data.sku_id).html(data.row);
                    }
                    soca.animation.alert(
                        '#skus',
                        'success',
                        'sku-' + messageVerb + '-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully ' + messageVerb + ' a variant.',
                        3500
                    )
                },
                error: function(xhr, evt, status)
                {
                    trado.admin.jsonErrors(xhr, evt, status, $this);
                }
            });
            return false;
        });
    },

    newStockAdjustment: function()
    {
        $('body').on('click', '#add-stock-adjustment-button', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#stock-adjustment-modal').html(data.modal);
                    soca.modal.standard('#stock-adjustment-form');
                }
            });
            return false;
        });
    },

    createStockAdjustments: function()
    {
        $('body').on('submit', '.amend-stock-adjustment', function()
        {
            var $this = $(this),
                url = $this.attr('action');
                
            $.ajax(
            {
                url: url,
                type: 'POST',
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#stock-table tbody tr:first-child td:last-child').removeClass('td-green');
                    $('#stock-table tbody').prepend(data.row);
                    $('#stock-adjustment-form').modal('hide');
                    soca.animation.alert(
                        '.page-header',
                        'success',
                        'stock-adjustment-create-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully created a new stock adjustment for ' + data.sku_name +'.',
                        5000
                    )
                },
                error: function(xhr, evt, status)
                {
                    trado.admin.jsonErrors(xhr, evt, status, $this);
                }
            });
            return false;
        });
    },

    newVariants: function()
    {
        $('body').on('click', '#sku-variant-options-button', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#sku-variants-modal').html(data.modal);
                    soca.modal.standard('#sku-variants-form');
                    $('.tagsinput').tagsinput();
                    if(data.active_skus)
                    {
                        $('.tagsinput').tagsinput('disable');
                    }
                }
            });
            return false;
        });
    },

    resetVariants: function()
    {
        $('body').on('click', '#reset-sku-variants-button', function ()
        {
            var url = $(this).attr('href');
            $.ajax(
            {
                url: url,
                type: "DELETE",
                dataType: "json",
                success: function(data)
                {
                    $('#sku-variants-form').modal('hide');
                    $('#add-sku-button').addClass('hide');
                    $('#skus').html('<div class="helper-notification"><p>You do not have any variants for this product.</p><i class="icon-tags"></i></div>');
                    soca.animation.alert(
                        '#skus',
                        'success',
                        'sku-variant-reset-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully reset the variants for this product.',
                        3500
                    )
                }
            });
            return false;
        });
    },

    amendVariants: function()
    {
        $('body').on('submit', '.amend-variants', function()
        {
            var $this = $(this),
                url = $this.attr('action'),
                method = $this.attr('data-method'),
                messageVerb;
                
            $.ajax(
            {
                url: url,
                type: method,
                data: $this.serialize(),
                dataType: 'json',
                success: function (data)
                {
                    $('#sku-variants-form').modal('hide');
                    if (method === 'POST')
                    {
                        messageVerb = 'created';
                        $('#add-sku-button').removeClass('hide');
                        $('#skus').html(data.table);
                    }
                    else
                    {   
                        messageVerb = 'deleted';
                        if (data.product_skus_empty)
                        {
                            $('#add-sku-button').addClass('hide');
                            $('#skus').html('<div class="helper-notification"><p>You do not have any variants for this product.</p><i class="icon-tags"></i></div>')
                        }
                        else
                        {
                            $('#skus').html(data.table);
                        }
                    }
                    soca.animation.alert(
                        '#skus',
                        'success',
                        'sku-variant-' + messageVerb + '-alert',
                        '<i class="icon-checkmark-circle"></i>Successfully ' + messageVerb + ' ' + data.sku_count_text + '.',
                        3500
                    )
                },
                error: function(xhr, evt, status)
                {
                    trado.admin.jsonErrors(xhr, evt, status, $this);
                }
            });
            return false;
        });
    },

    showTransaction: function()
    {
        $('body').on('click', '.transaction-info-modal', function ()
        {
            var transactionId = $(this).attr('data-record-id');
            $.ajax(
            {
                url: '/admin/transactions/' + transactionId,
                type: "GET",
                dataType: "json",
                success: function(data)
                {
                    $('.main .container').removeClass('fadeIn');
                    $('#transaction-modal').html(data.modal);
                    soca.modal.standard('#transaction-info');
                }
            });
            return false;
        });
    },
}