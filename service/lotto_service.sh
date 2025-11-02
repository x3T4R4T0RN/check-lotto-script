#!/bin/bash
source ./repository/lotto_api_repository.sh

# -------------------------------
# Function: lotto_summary
# -------------------------------
# - Parse key info from lotto JSON
# - Args: JSON string
# - Output: formatted summary
# -------------------------------
show_summary() {
    local json="$1"

    local date
    date=$(echo "$json" | jq -r '.response.date')

    local first_prize
    first_prize=$(echo "$json" | jq -r '.response.prizes[] | select(.id=="prizeFirst") | .number | join(" ")')

    local last_two
    last_two=$(echo "$json" | jq -r '.response.runningNumbers[] | select(.id=="runningNumberBackTwo") | .number | join(" ")')

    local first_three
    first_three=$(echo "$json" | jq -r '.response.runningNumbers[] | select(.id=="runningNumberFrontThree") | .number | join(" ")')

    local last_three
    last_three=$(echo "$json" | jq -r '.response.runningNumbers[] | select(.id=="runningNumberBackThree") | .number | join(" ")')

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