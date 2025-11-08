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
	echo "🌀 Starting fetch latest lottery result...\n" >&2
	local url="${LOTO_API_URL}${LATEST_PATH}"

	local response
	response=$(curl -s "$url")

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
