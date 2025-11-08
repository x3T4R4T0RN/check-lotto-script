#!/bin/bash

write_to_file() {
    local data="$1"
    local directory="$2"
    local location="${2}/${3}"
    
    mkdir -p "$directory" || {
        echo "❌ Cannot create directory: $RESPONSE_LATEST_DIRECTORY"
        return 1
    }
    
    echo "$data" > "$location"
}

read_from_file() {
    if [ ! -f "$1" ]; then
        return 1
    fi

    local data=$(<"$1")
    echo "$data"

}