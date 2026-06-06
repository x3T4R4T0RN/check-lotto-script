#!/bin/bash

is_valid_lotto_json() {
	local json="$1"
	[ -n "$json" ] && echo "$json" | jq -e '.status == "success" and (.response | type == "object")' >/dev/null 2>&1
}

get_lotto_summary_fields() {
	local json="$1"

	echo "$json" | jq -r '
		def numbers_text: if type == "array" then join(" ") else . // "" end;

		[
			.response.date,
			(.response.prizes[]? | select(.id == "prizeFirst") | .number | numbers_text),
			(.response.runningNumbers[]? | select(.id == "runningNumberFrontThree") | .number | numbers_text),
			(.response.runningNumbers[]? | select(.id == "runningNumberBackThree") | .number | numbers_text),
			(.response.runningNumbers[]? | select(.id == "runningNumberBackTwo") | .number | numbers_text)
		] | @tsv
	'
}

get_lotto_prize_matches() {
	local json="$1"
	local search_number="$2"
	local search_length=${#search_number}
	local first_three=""
	local last_three=""
	local last_two=""

	[ "$search_length" -ge 3 ] && first_three="${search_number:0:3}"
	[ "$search_length" -ge 3 ] && last_three="${search_number:$((search_length - 3)):3}"
	[ "$search_length" -ge 2 ] && last_two="${search_number:$((search_length - 2)):2}"

	echo "$json" | jq -r \
		--arg num "$search_number" \
		--arg len "$search_length" \
		--arg first_three "$first_three" \
		--arg last_three "$last_three" \
		--arg last_two "$last_two" '
		def numbers: if (.number | type) == "array" then .number[]? else .number // empty end;
		def reward_value: (.reward // "0" | tonumber? // 0);

		([
			.response.prizes[]? as $prize
			| ($prize | numbers) as $number
			| select($number == $num)
			| {
				icon: "🏆",
				name: $prize.name,
				number: $number,
				reward: ($prize.reward // "0"),
				rewardValue: ($prize | reward_value)
			}
		] + [
			.response.runningNumbers[]? as $running
			| ($running | numbers) as $number
			| select(
				($len == "6" and (
					($running.id == "runningNumberFrontThree" and $number == $first_three) or
					($running.id == "runningNumberBackThree" and $number == $last_three) or
					($running.id == "runningNumberBackTwo" and $number == $last_two)
				)) or
				($len != "6" and $number == $num)
			)
			| {
				icon: "💰",
				name: $running.name,
				number: $number,
				reward: ($running.reward // "0"),
				rewardValue: ($running | reward_value)
			}
		])
		| sort_by(-.rewardValue)
		| .[]
		| [.icon, .name, .number, .reward] | @tsv
	'
}

get_lotto_date() {
	local json="$1"
	echo "$json" | jq -r '.response.date // empty'
}
