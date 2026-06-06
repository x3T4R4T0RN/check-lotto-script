#!/bin/bash

show_summary() {
	local json="$1"
	local summary_fields
	summary_fields=$(get_lotto_summary_fields "$json")

	local date first_prize first_three last_three last_two
	IFS=$'\t' read -r date first_prize first_three last_three last_two <<< "$summary_fields"

	sleep 0.5
	printf "\n===================================="
	sleep 0.5
	printf "\n=======   🎯 Lotto Summary   =======\n"
	sleep 0.5
	printf "====================================\n"
	sleep 0.5
	printf "📅 งวดวันที่       : %s\n" "$date"
	sleep 0.5
	printf "🏆 รางวัลที่ 1     : %s\n" "$first_prize"
	sleep 0.5
	printf "💰 เลขหน้า 3 ตัว  : %s\n" "$first_three"
	sleep 0.5
	printf "💰 เลขท้าย 3 ตัว  : %s\n" "$last_three"
	sleep 0.5
	printf "💵 เลขท้าย 2 ตัว  : %s\n" "$last_two"
	sleep 0.5
	printf "====================================\n\n"
}

show_date() {
	local json="$1"
	local date
	date=$(get_lotto_date "$json")

	echo "------------------------------------"
	echo "📅 งวดวันที่: $date"
	echo "------------------------------------"
}

show_lotto_result() {
	local search_number="$1"
	local prize_lines="$2"
	local number_text="🔎 สลากหมายเลข: $search_number "

	if [[ -n "$prize_lines" ]]; then
		echo "$number_text"
		while IFS=$'\t' read -r icon name matched_number reward; do
			echo "$icon ถูกรางวัล: $name | เลขที่ถูก: $matched_number | เงินรางวัล: $reward บาท"
		done <<< "$prize_lines"
	else
		echo "$number_text ❌ คุณไม่ถูกรางวัล"
	fi
}

show_missing_find_numbers() {
	echo "⚠️  กรุณาใส่หมายเลขหลัง -f เช่น:"
	echo "   ./main.sh -f 123456 789001"
}

show_invalid_lottery_number() {
	local number="$1"
	echo "[$number] ❌ เลขไม่ถูกต้อง"
}

show_find_footer() {
	echo "------------------------------------"
}

show_unknown_operation() {
	echo "😐 WTF"
}
