#!/bin/bash

BASE_URL="https://lotto.api.rayriffy.com/"
LATEST_PATH="latest"

fetch_latest_lotto() {
    echo "🌀 Fetching latest lottery result..." >&2
    local url="${BASE_URL}${LATEST_PATH}"

    # Fetch API response (quiet mode)
    local response
    response=$(curl -s "$url")

    # Extract status field
    local status
    status=$(echo "$response" | jq -r '.status' 2>/dev/null)

    # Check status
    if [ "$status" == "success" ]; then
        echo "✅ Success to fetch latest lotto data" >&2
        echo "$response"        # ✅ send JSON to stdout
        return 0
    else
        echo "❌ Failed to fetch latest lotto data" >&2
        return 1
    fi
}