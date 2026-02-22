#!/usr/bin/env bash
STATUS=$(mullvad status)
if echo "$STATUS" | grep -q "Connected"; then
    LOCATION=$(echo "$STATUS" | grep "Visible location:" | sed 's/.*Visible location:[[:space:]]*//' | cut -d'.' -f1)
    echo "{\"text\": \"$LOCATION\", \"class\": \"connected\"}"
else
    echo "{\"text\": \"no vpn\", \"class\": \"disconnected\"}"
fi
