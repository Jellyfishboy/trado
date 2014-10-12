trado.misc =
{
    log: function(message) 
    {
        if (typeof console === 'object') 
        {
            return console.log(message);
        } 
        else 
        {
            return null;
        }
    }
}