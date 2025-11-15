#!/bin/bash

validate_lottery_format() {
    local input="$1"
    if [[ "$input" =~ ^[0-9]{1,6}$ ]]; then
        return 0
    else
        return 1
    fi
}