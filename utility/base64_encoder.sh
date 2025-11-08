#!/bin/bash

# --- Base64 Encode ---------------------------------------------------
# Encodes a given string into Base64 format.
# Arguments:
#   $1 - The input text to encode
# Output:
#   Base64-encoded string
# --------------------------------------------------------------------
base64_encode() {
	local input="$1"
	echo -n "$input" | base64
}

# --- Base64 Decode ---------------------------------------------------
# Decodes a given Base64 string back to plain text.
# Arguments:
#   $1 - The Base64-encoded input string
# Output:
#   Decoded plain text
# --------------------------------------------------------------------
base64_decode() {
	local input="$1"
	echo -n "$input" | base64 --decode
}
