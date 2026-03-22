#!/usr/bin/env bash

country_to_flag() {
    local cc=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local offset=127397
    printf "\U$(printf %x $((offset + $(printf '%d' "'${cc:0:1}"))))"
    printf "\U$(printf %x $((offset + $(printf '%d' "'${cc:1:1}"))))"
}

mullvad status listen | while IFS= read -r line; do
    status=$(mullvad status)
    if echo "$status" | grep -q "Connected"; then
        country=$(echo "$status" | grep "Relay:" | awk '{print $2}' | cut -d'-' -f1)
        city=$(echo "$status" | grep "Visible location:" | sed -n 's/.*,\s*\([^.]*\)\..*/\1/p')
        flag=$(country_to_flag "$country")
        echo "$flag$city"
    else
        echo "no vpn"
    fi
done
