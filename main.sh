#!/bin/bash

set -a
source "$(dirname "$0")/.env"
set +a

source ./utility/logging.sh
source ./utility/base64_encoder.sh
source ./utility/aes_encryption.sh
source ./repository/lotto_file_repository.sh
source ./repository/lotto_api_repository.sh
source ./service/cache_service.sh
source ./service/lotto_service.sh
source ./service/lotto_presenter_service.sh
source ./service/lotto_validator_service.sh
source ./service/lotto_application_service.sh
source ./service/opt_service.sh

main() {
	mapopt "$@"
	local json

	if ! json=$(load_latest_lotto_data); then
		return 1
	fi

	if [ "$FLAG_FIND" = true ]; then
		shift
		check_lottery_numbers "$json" "$@"
	elif [ "$FLAG_SUMMARY" = true ]; then
		show_summary "$json"
	else
		show_unknown_operation
	fi
}

main "$@"
