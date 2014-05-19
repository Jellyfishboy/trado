trado.admin =
{
    jsonErrors: function() 
    {
        $(document).on("ajax:error", "form", function(evt, xhr, status, error) 
        {
            var content, value, _i, _len, _ref;
            content = $(this).children('#errors');
            content.find('ul').empty();
            _ref = $.parseJSON(xhr.responseText).errors;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) 
            {
                value = _ref[_i];
                content.show().find('ul').append('<li><i class="icon-cancel-circle"></i>' + value + '</li>');
            }
            if (!$(this).parent().hasClass('modal-content')) 
            {
                $('body').scrollTo('.page-header', 800);
            }
            $('.new-file').css('background-color', '#00aff1').children('.icon-upload-3').css('top', '41px');
            return $('.new-file').children('div').empty();
      });
    },

    taxField: function()
    {   
        var $elem = $('.calculate-tax');
        $elem.each(function() 
        {
            return $(this).closest('input').after('<div class="gross">Gross amount: ' + parseFloat(trado.misc.taxify(this.value), 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString() + '</div>');
        });
        $elem.bind("input", function() 
        {
            return $(this).next('.gross').text('Gross amount: ' + parseFloat(trado.misc.taxify(this.value)).toFixed(2));
        });
    },

    addField: function(link, association, content, target) 
    {
        var newId, regExp;
        newId = new Date().getTime();
        regExp = new RegExp("new_" + association, "g");
        return $(target).append(content.replace(regExp, newId));
    },

    removeField: function(link, obj) 
    {
        var $elem, $elements;
        $elements = $('.' + obj + '.ajax-fields');
        if ($elements.length > 1 || $elements.parent().hasClass('edit-field')) 
        {
            $(link).prev("input[type=hidden]").val("1");
            $elem = $(link).closest(".ajax-fields");
            if (obj === "attachments") 
            {
                $elem.next("input[type=file]").remove();
            }
            return $elem.remove();
        }
    }

}