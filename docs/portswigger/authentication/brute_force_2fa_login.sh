#!/bin/bash

curl -s -X 'GET' -c "$3/$1.file" \
    --url "$2/login" \
    --retry 10 | grep -Po "(?<=csrf\" value=\")[^\"]*" | xargs -n1 -I% \
        curl -s -X 'POST' -c "$3/$1.file" -b "$3/$1.file" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            --data "csrf=%&username=carlos&password=montoya" \
            --url "$2/login"
