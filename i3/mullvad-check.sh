#!/usr/bin/env bash
STATUS=$(mullvad status)
if echo "$STATUS" | grep -q "Connected"; then
    LOCATION=$(echo "$STATUS" | grep "Visible location:" | sed 's/.*Visible location:[[:space:]]*//' | cut -d'.' -f1)
    echo "󰴳 $LOCATION"
else
    echo "󰦞 not connected"
fi
