# Thailand Lottery Checker Script
A shell script utility for checking Thailand lottery numbers - perfect for lazy guy. Hahaha 😂


### Installation
- Clone or download the script
- Make it executable: chmod +x main
---
### Usage
#### Get summary
```bash
$ ./main.sh -s 
```
#### Find prize
```bash
$ ./main.sh -f <numbers ...> 
```
#### Quick Help
```bash
$ ./main.sh -h
```
---
### Features
- Quick lottery number verification
- Checks full 6-digit tickets against first prize, first 3 digits, last 3 digits, and last 2 digits
- Command-line interface for easy automation
- Support for multiple number checking in a single command
---
### Project Structure
```text
.
├── main.sh
├── repository/
│   ├── lotto_api_repository.sh
│   └── lotto_file_repository.sh
├── service/
│   ├── cache_service.sh
│   ├── lotto_application_service.sh
│   ├── lotto_presenter_service.sh
│   ├── lotto_service.sh
│   ├── lotto_validator_service.sh
│   └── opt_service.sh
└── utility/
    ├── aes_encryption.sh
    ├── base64_encoder.sh
    └── logging.sh
```

### Architecture Overview
- `main.sh` is the CLI entrypoint. It loads dependencies, parses options, and dispatches commands.
- `repository/` contains data access code, such as fetching lottery data from the API and writing cache files.
- `service/lotto_service.sh` contains lottery domain logic, including JSON validation, summary extraction, and prize matching.
- `service/lotto_application_service.sh` coordinates application use cases, such as loading cached data, refreshing API data, and checking numbers.
- `service/lotto_presenter_service.sh` handles terminal output formatting only.
- `service/cache_service.sh` manages encrypted cache read/write behavior.
- `service/lotto_validator_service.sh` validates user input format.
- `service/opt_service.sh` maps CLI options to application flags.
- `utility/` contains reusable low-level helpers for logging, Base64 encoding, and AES encryption.

The code is organized to keep business logic, presentation, infrastructure, and orchestration separate. This makes the script easier to test, maintain, and extend while preserving a simple shell-based workflow.
---
### Remark
This project is intended for:
- Educational purposes
- Internal use only
- Learning shell scripting concepts 
