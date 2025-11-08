#!/bin/bash

get_cache_latest_lotto() {
	local fp="${CACHE_DIRECTORY}/${CACHE_LATEST_FILENAME}"

	if [ ! -f "$fp" ]; then
		warn "Could not find cache data"
		return 1
	fi

	local raw=$(<"$fp")
	local decoded=$(base64_decode "$raw")

	local key=$(base64_decode "$CACHE_KEY")
	local decrypted=$(aes_decrypt "$decoded" "$key")
	local data=$(echo "$decrypted" | jq -r)
	local timestamp=$(echo "$decrypted" | jq -r '.timestamp // empty')

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

	local json=$(echo "$decrypted" | jq -r '.result // empty')
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
	local pstr=$(echo "$wrapped_json" | jq -c .)
	local key=$(base64_decode "$CACHE_KEY")
	local encyt=$(aes_encrypted "$pstr" "$key")
	local encoded=$(base64_encode "$encyt")
	write_to_file "$encoded" "${CACHE_DIRECTORY}" "${CACHE_LATEST_FILENAME}"
}
