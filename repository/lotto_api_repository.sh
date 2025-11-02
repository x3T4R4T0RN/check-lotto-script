#!/bin/bash

BASE_URL="https://lotto.api.rayriffy.com/"
LATEST_PATH="latest"

fetch_latest_lotto() {
    echo "🌀 Starting fetch latest lottery result...\n" >&2
    local url="${BASE_URL}${LATEST_PATH}"

    local response
    response=$(curl -s "$url")


    local status
    status=$(echo "$response" | jq -r '.status' 2>/dev/null)

    if [ "$status" == "success" ]; then
        echo "✅ Fetch latest lotto data success" >&2
        echo "$response"
        return 0
    else
        echo "❌ Failed to fetch latest lotto data." >&2
        return 1
    fi
}