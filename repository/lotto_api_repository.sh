#!/bin/bash

# BASE_URL="https://lotto.api.rayriffy.com/"
# LATEST_PATH="latest"

# -------------------------------
# Function: fetch_latest_lotto
# -------------------------------
# - Fetch lotto data form api
# - Output: JSON response
# -------------------------------
fetch_latest_lotto() {
	log "🌀 Starting fetch latest lottery result..."
	local lttbse=$(base64_decode $LOTO_API_URL)
	local lttlst=$(base64_decode $LATEST_PATH)

	local response=$(curl -s "${lttbse}${lttlst}")

	local status
	status=$(echo "$response" | jq -r '.status' 2>/dev/null)

	if [ "$status" == "success" ]; then
		success "Fetch latest lotto data success"
		echo "$response"
		return 0
	else
		fail "Failed to fetch latest lotto data."
		return 1
	fi
}
