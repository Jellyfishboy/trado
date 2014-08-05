trado.filter =
{
    ///////////////////////////////////
    // Filter target
    ///////////////////////////////////
    tableRowTarget: function()
    {
        $("tbody.mixitup").mixItUp(
        {
          layout: 
          {
            display: "table-row"
          },
          animation: 
          {
            effects: "fade",
            duration: "400"
          }
        });
    },

    ///////////////////////////////////
    // Type of filter
    ///////////////////////////////////
    products: function()
    {
        $('#filter-product-category').on('change', function() 
        {
          var item;
          item = $(this).find(':selected').data('filter');
          return $('.mixitup').mixItUp('filter', item);
        });

        $('#sort-product').on('change', function() 
        {
          var item;
          item = $(this).find(':selected').data('sort');
          return $('.mixitup').mixItUp('sort', item);
        });
    }
}