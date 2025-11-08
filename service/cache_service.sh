#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../repository/lotto_file_repository.sh"

get_cache_latest_lotto() {
	local fp="${CACHE_DIRECTORY}/${CACHE_LATEST_FILENAME}"

	if [ ! -f "$fp" ]; then
		warn "Could not find cache data"
		return 1
	fi

	local raw=$(<"$fp")

	local data=$(echo "$raw" | jq -r)

	local timestamp=$(echo "$raw" | jq -r '.timestamp // empty')

	if [ ! -n "$timestamp" ]; then
		warn "Could not find any caching time."
		return 1
	fi

	local curtime=$(date '+%s')
	local diff=$((curtime - timestamp))

	if [ "$diff" -gt $DEBOUNCH_TIME ]; then
		warn "Cache expired."
		return 1
	fi

	local json=$(echo "$raw" | jq -r '.result // empty')
	echo "$json"
}

set_cache_latest_lotto() {
	local data=$1
	local timestamp=$(date '+%s')
	local wrapped_json=$(
		jq -n \
			--arg time "${timestamp}" \
			--argjson data "$data" \
			'{timestamp: $time, result: $data}'
	)
	local plain_string=$(echo "$wrapped_json" | jq -c .)
	write_to_file "$plain_string" "${CACHE_DIRECTORY}" "${CACHE_LATEST_FILENAME}"
}
