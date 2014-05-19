trado.app =
{
    updatePrice: function(url, queryString, elem, elemTwo)
    {
        $(elem).change(function() {
            var id, idTwo;
            id = $(this).val();
            idTwo = $(elemTwo).val();
            return $.get(url.concat(id, queryString, idTwo));
        });
    }
}