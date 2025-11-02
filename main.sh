
#!/bin/bash

source ./service/lotto_service.sh
source ./service/opt_service.sh

find() {
    local json="$1"
    shift
    local numbers=("$@")

    if [ ${#numbers[@]} -eq 0 ]; then
        echo "⚠️  กรุณาใส่หมายเลขหลัง -f เช่น:"
        echo "   ./main.sh -f 123456 789001"
        return 1
    fi

    show_date "$json"
    sleep 0.5

    for number in "${numbers[@]}"; do
        find_number "$json" "$number"
        sleep 0.5
    done
    echo "------------------------------------"
}

main() {
    mapopt "$@"
    
    local json=$(fetch_latest_lotto)
    local exit_code=$?
    sleep 1
    clear

    if [ $exit_code -ne 0 ]; then
        echo "⚠️  Cannot get lotto data." >&2
        exit 1
    fi

    if [ "$FLAG_FIND" = true ]; then
        shift
        find "$json" "$@"
    elif [ "$FLAG_SUMMARY" = true ]; then
        show_summary "$json"
    else 
        echo "😐 WTF"
    fi
}

main "$@"