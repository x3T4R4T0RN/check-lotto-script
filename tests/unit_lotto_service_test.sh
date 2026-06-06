#!/bin/bash

set -euo pipefail

source ./service/lotto_service.sh
source ./service/lotto_validator_service.sh

pass_count=0

assert_equal() {
	local expected="$1"
	local actual="$2"
	local message="$3"

	if [ "$expected" != "$actual" ]; then
		echo "FAIL: $message"
		echo "Expected: $expected"
		echo "Actual  : $actual"
		exit 1
	fi

	pass_count=$((pass_count + 1))
}

assert_success() {
	local message="$1"
	shift

	if ! "$@"; then
		echo "FAIL: $message"
		exit 1
	fi

	pass_count=$((pass_count + 1))
}

assert_failure() {
	local message="$1"
	shift

	if "$@"; then
		echo "FAIL: $message"
		exit 1
	fi

	pass_count=$((pass_count + 1))
}

fixture_json='{
  "status": "success",
  "response": {
    "date": "1 มิถุนายน 2569",
    "prizes": [
      {
        "id": "prizeFirst",
        "name": "รางวัลที่ 1",
        "reward": "6000000",
        "number": ["173770"]
      },
      {
        "id": "prizeFifth",
        "name": "รางวัลที่ 5",
        "reward": "20000",
        "number": ["848495"]
      }
    ],
    "runningNumbers": [
      {
        "id": "runningNumberFrontThree",
        "name": "รางวัลเลขหน้า 3 ตัว",
        "reward": "4000",
        "number": ["848", "415"]
      },
      {
        "id": "runningNumberBackThree",
        "name": "รางวัลเลขท้าย 3 ตัว",
        "reward": "4000",
        "number": ["410", "938"]
      },
      {
        "id": "runningNumberBackTwo",
        "name": "รางวัลเลขท้าย 2 ตัว",
        "reward": "2000",
        "number": ["95"]
      }
    ]
  }
}'

assert_success "valid lotto JSON passes validation" is_valid_lotto_json "$fixture_json"
assert_failure "invalid lotto JSON fails validation" is_valid_lotto_json '{"status":"success"}'

summary_fields=$(get_lotto_summary_fields "$fixture_json")
assert_equal $'1 มิถุนายน 2569	173770	848 415	410 938	95' "$summary_fields" "summary fields are extracted"

first_prize_match=$(get_lotto_prize_matches "$fixture_json" "173770")
assert_equal $'🏆	รางวัลที่ 1	173770	6000000' "$first_prize_match" "exact first prize match is returned"

multi_match=$(get_lotto_prize_matches "$fixture_json" "848495")
assert_equal $'🏆	รางวัลที่ 5	848495	20000
💰	รางวัลเลขหน้า 3 ตัว	848	4000
💰	รางวัลเลขท้าย 2 ตัว	95	2000' "$multi_match" "multiple matches are sorted by reward descending"

direct_three_match=$(get_lotto_prize_matches "$fixture_json" "410")
assert_equal $'💰	รางวัลเลขท้าย 3 ตัว	410	4000' "$direct_three_match" "direct 3-digit match is returned"

direct_two_match=$(get_lotto_prize_matches "$fixture_json" "95")
assert_equal $'💰	รางวัลเลขท้าย 2 ตัว	95	2000' "$direct_two_match" "direct 2-digit match is returned"

no_match=$(get_lotto_prize_matches "$fixture_json" "000000")
assert_equal "" "$no_match" "non-winning number returns empty result"

assert_success "valid 6-digit input passes validation" validate_lottery_format "123456"
assert_success "valid 2-digit input passes validation" validate_lottery_format "95"
assert_failure "alphabet input fails validation" validate_lottery_format "abc"
assert_failure "more than 6 digits fails validation" validate_lottery_format "1234567"

echo "PASS: $pass_count unit tests"
