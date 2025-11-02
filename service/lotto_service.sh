#!/bin/bash
source ./repository/lotto_api_repository.sh

# -------------------------------
# Function: parse_lotto_summary
# -------------------------------
# - Parse key info from lotto JSON
# - Args: JSON string
# - Output: formatted summary
# -------------------------------
lotto_summary() {
    local json="$1"

    local date
    date=$(echo "$json" | jq -r '.response.date')

    local first_prize
    first_prize=$(echo "$json" | jq -r '.response.prizes[] | select(.id=="prizeFirst") | .number[0]')

    local last_two
    last_two=$(echo "$json" | jq -r '.response.runningNumbers[] | select(.id=="runningNumberBackTwo") | .number[0]')

    printf "\n🎯 Lotto Summary\n"
    printf "#####################################\n"
    printf "📅 งวดวันที่       : %s\n" "$date"
    printf "🏆 รางวัลที่ 1     : %s\n" "$first_prize"
    printf "💰 เลขท้าย 2 ตัว   : %s\n" "$last_two"
    printf "#####################################\n\n"
}

# -------------------------------
# Function: find_number
# -------------------------------
# - Args: 1. JSON string
#         2. Number of lotto
# - Output: Prize
# -------------------------------
find_number() {
    local json="$1"
    local search_number="$2"

    local prize_name
    prize_name=$(echo "$json" | jq -r --arg num "$search_number" '
        .response.prizes[] | select(.number[]? == $num) | .name
    ')

    local running_name
    running_name=$(echo "$json" | jq -r --arg num "$search_number" '
        .response.runningNumbers[] | select(.number[]? == $num) | .name
    ')
    number_text="🔎 สลากหมายเลข: $search_number "
    # printf "🔎 สลากหมายเลข: %s\n" "$search_number"
    if [[ -n "$prize_name" || -n "$running_name" ]]; then
        [[ -n "$prize_name" ]] && echo "$number_text 🏆 ถูกรางวัล: $prize_name"
        [[ -n "$running_name" ]] && echo "$number_text 💰 ถูกรางวัล: $running_name"
    else 
        echo "$number_text ❌ คุณไม่ถูกรางวัล"
    fi

}

# -------------------------------
# Function: show_date
# -------------------------------
# - Args: JSON string
# - Output: Date of lotto
# -------------------------------
show_date() {
    local json="$1"
    date=$(echo "$json" | jq -r '.response.date')
    echo "-------------------------------"
    echo "📅 งวดวันที่: $date"
    echo "-------------------------------"
}