trado.misc =
{
    log: function(message) 
    {
        if (typeof console === 'object') {
            return console.log(message);
        } 
        else 
        {
            return null;
        }
    },

    taxify: function(value)
    {
        var number, sum;
        number = Number(value);
        sum = number + (number*0.2)
        return if isNaN(sum) ? 0 : sum
    }

}