#!/bin/bash

# -------------------------------
# Function: warn
# -------------------------------
# - Print a warning message with ⚠️ prefix
# - Args:
#     $1 - Warning message text
# - Output: Prints to stderr
# -------------------------------
warn() {
	printf "⚠️  %s\n" "$1" >&2
}

# -------------------------------
# Function: success
# -------------------------------
# - Print a success message with 🟢 prefix
# - Args:
#     $1 - Success message text
# - Output: Prints to stderr
# -------------------------------
success() {
	printf "🟢  %s\n" "$1" >&2
}

# -------------------------------
# Function: fail
# -------------------------------
# - Print an error/failure message with ⛔️ prefix
# - Args:
#     $1 - Error message text
# - Output: Prints to stderr
# -------------------------------
fail() {
	printf "⛔️  %s\n" "$1" >&2
}

# -------------------------------
# Function: log
# -------------------------------
# - Print a general info message with 📢 prefix
# - Args:
#     $1 - Log message text
# - Output: Prints to stderr
# -------------------------------
log() {
	printf "📢  %s\n" "$1" >&2
}
