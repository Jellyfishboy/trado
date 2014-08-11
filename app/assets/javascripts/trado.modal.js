trado.modal =
{
    loading: function(trigger, target) 
    {
        $(trigger).click(function() 
        {
            $(target).modal('show');
            return $(target + ' .modal-body .loading-block').spin('standard');
        });
    },
    
    open: function(trigger, target)
    {
        $(trigger).click(function() 
        {
           $(target).modal('show');
           return false;
        });
    },

    ajaxOpen: function(elem, url, urlEnd)
    {   
        $('body').on('click', elem, function() 
        {
            // Stop the page transition animation style disabling the z-index order for the modal
            $('.main .container').removeClass('fadeIn');
            var id;
            id = $(this).attr('id');
            if (urlEnd)
            {
                return $.get(url.concat(id, urlEnd));
            }
            else
            {
                return $.get(url.concat(id));
            }
        });
    }
}