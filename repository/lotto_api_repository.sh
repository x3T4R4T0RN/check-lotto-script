#!/bin/bash

# LATEST_URL="https://thai-lottery-api-two.vercel.app/api/lotto"

# -------------------------------
# Function: fetch_latest_lotto
# -------------------------------
# - Fetch lotto data form api
# - Output: JSON response
# -------------------------------
fetch_latest_lotto() {
	log "🌀 Starting fetch latest lottery result..."
	local url="https://thai-lottery-api-two.vercel.app/api/lotto"

	local response
	if ! response=$(curl -fsSL --connect-timeout 10 --max-time 30 "$url" 2>/dev/null); then
		fail "Failed to fetch latest lotto data from API."
		return 1
	fi

	local normalized
	normalized=$(echo "$response" | jq -c '
		if .status == "success" and (.response | type) == "object" then
			.
		elif .status == "success" and (.data | type) == "object" then
			{status: .status, response: .data}
		else
			.
		end
	' 2>/dev/null)

	local status
	status=$(echo "$normalized" | jq -r '.status // empty' 2>/dev/null)

	if [ "$status" == "success" ]; then
		success "Fetch latest lotto data success"
		echo "$normalized"
		return 0
	else
		fail "Failed to fetch latest lotto data."
		return 1
	fi
}
