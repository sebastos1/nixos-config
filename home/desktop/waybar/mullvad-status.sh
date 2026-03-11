#!/usr/bin/env bash

# twemoji convert
country_to_flag() {
    local cc=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local offset=127397
    printf "\U$(printf %x $((offset + $(printf '%d' "'${cc:0:1}"))))"
    printf "\U$(printf %x $((offset + $(printf '%d' "'${cc:1:1}"))))"
}

status=$(mullvad status)
if echo "$status" | grep -q "Connected"; then

    # get country from relay line (us-sjc-wg-504)
    country=$(echo "$status" | grep "Relay:" | awk '{print $2}' | cut -d'-' -f1)

    # get city from visible location:
    city=$(echo "$status" | grep "Visible location:" | sed -n 's/.*,\s*\([^.]*\)\..*/\1/p')

    flag=$(country_to_flag "$country")

    echo "{\"text\": \"<span font='Twitter Color Emoji'>$flag</span> $city\", \"class\": \"connected\"}"
else
    echo "{\"text\": \"no vpn\", \"class\": \"disconnected\"}"
fi
