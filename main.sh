
#!/bin/bash

source ./service/lotto_service.sh

main() {

    local json
    json=$(fetch_latest_lotto)
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
    show_date "$json"

    for number in "${numbers[@]}"; do
        find_number "$json" "$number"
    done

    else
        echo "⚠️  Cannot get lotto data. Exiting." >&2
        exit 1
    fi
}

numbers=("$@")
main "${numbers[@]}"