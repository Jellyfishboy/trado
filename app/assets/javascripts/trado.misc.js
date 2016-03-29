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
    },

    getUrlVars: function(queryHash)
    {
        var queryHash = (queryHash == null ? window.location.href.slice(window.location.href.indexOf('?') + 1) : decodeURIComponent(queryHash))
        var vars = [], hash;
        var hashes = queryHash.split('&');
        for(var i = 0; i < hashes.length; i++)
        {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    }
}