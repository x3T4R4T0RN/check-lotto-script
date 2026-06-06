#!/bin/bash

load_latest_lotto_data() {
	local json
	json=$(get_cache_latest_lotto)

	if is_valid_lotto_json "$json"; then
		echo "$json"
		return 0
	fi

	if ! json=$(fetch_latest_lotto) || ! is_valid_lotto_json "$json"; then
		fail "Cannot load latest lottery data."
		return 1
	fi

	set_cache_latest_lotto "$json"
	echo "$json"
}

check_lottery_numbers() {
	local json="$1"
	shift
	local numbers=("$@")

	if [ ${#numbers[@]} -eq 0 ]; then
		show_missing_find_numbers
		return 1
	fi

	show_date "$json"

	local number prize_lines
	for number in "${numbers[@]}"; do
		if validate_lottery_format "$number"; then
			prize_lines=$(get_lotto_prize_matches "$json" "$number")
			show_lotto_result "$number" "$prize_lines"
		else
			show_invalid_lottery_number "$number"
		fi
	done

	show_find_footer
}
